import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import { existsSync } from "node:fs";
import { join, resolve } from "node:path";
import { changedFiles, dartFiles, importGraph, type Snapshot, snapshot, testsTouching } from "./dart-files.ts";

const root = resolve(import.meta.dirname, "../../..");
const checkTimeoutMs = 10 * 60 * 1000;
const outputTailLines = 60;

type Check = { label: string; command: string; args: string[] };
type Outcome = { label: string; passed: boolean; detail: string };

export default function dartChecks(pi: ExtensionAPI) {
	pi.setLabel("Dart checks");

	let baseline: Snapshot = new Map();
	const edited = new Set<string>();

	const collect = async () => {
		const current = await snapshot(root);
		for (const file of changedFiles(baseline, current)) edited.add(file);
		baseline = current;
	};

	const run = async ({ label, command, args }: Check): Promise<Outcome> => {
		const result = await pi.exec(command, args, { cwd: root, signal: AbortSignal.timeout(checkTimeoutMs) });
		const output = `${result.stdout}\n${result.stderr}`.trim().split("\n").slice(-outputTailLines).join("\n");
		const passed = result.code === 0 && !result.killed;
		return { label, passed, detail: passed ? "" : `exit ${result.code}${result.killed ? " (killed)" : ""}\n${output}` };
	};

	pi.on("session_start", async () => {
		baseline = await snapshot(root);
	});

	pi.on("agent_start", async () => {
		baseline = await snapshot(root);
	});

	pi.on("session_stop", async (_event, ctx) => {
		await collect();
		if (edited.size === 0) return;

		const files = [...edited].sort();
		const present = files.filter(file => existsSync(join(root, file)));
		const graph = await importGraph(root, await dartFiles(root));
		const tests = testsTouching(graph, files);

		const checks: Check[] = [
			{ label: "dart analyze --fatal-infos", command: "dart", args: ["analyze", "--fatal-infos"] },
			...(present.length > 0
				? [
						{
							label: "dart format --set-exit-if-changed",
							command: "dart",
							args: ["format", "--output=none", "--set-exit-if-changed", ...present],
						},
					]
				: []),
			...(tests.length > 0
				? [
						{
							label: `flutter test (${tests.length} file${tests.length === 1 ? "" : "s"})`,
							command: "flutter",
							args: ["test", "--reporter", "failures-only", ...tests],
						},
					]
				: []),
		];

		const outcomes: Outcome[] = [];
		for (const check of checks) outcomes.push(await run(check));

		const summary = outcomes.map(({ label, passed }) => `${passed ? "PASS" : "FAIL"}  ${label}`).join("\n");
		const testsLine = tests.length > 0 ? `Tests: ${tests.join(", ")}` : "Tests: none import the edited files";

		if (outcomes.every(outcome => outcome.passed)) {
			edited.clear();
			ctx.ui.notify(`Dart checks passed for ${files.length} edited file(s)\n${summary}`, "info");
			return;
		}

		const failures = outcomes
			.filter(outcome => !outcome.passed)
			.map(({ label, detail }) => `--- ${label}\n${detail}`)
			.join("\n\n");
		return {
			decision: "block",
			reason: [
				`Dart checks failed after editing: ${files.join(", ")}`,
				summary,
				testsLine,
				failures,
				"Fix every failure, then finish the turn again.",
			].join("\n\n"),
		};
	});
}
