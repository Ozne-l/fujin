import { readdir, readFile, stat } from "node:fs/promises";
import { dirname, join, normalize } from "node:path";

const sourceRoots = ["lib", "test", "tool"];
const dartSuffix = ".dart";
const testSuffix = "_test.dart";
const testRoot = "test/";
const packagePrefix = "package:fujin/";
const directive = /^\s*(?:import|export|part)\s+['"]([^'"]+)['"]/gm;

export type Snapshot = Map<string, number>;

export async function dartFiles(root: string): Promise<string[]> {
	const found: string[] = [];
	for (const sourceRoot of sourceRoots) {
		const entries = await readdir(join(root, sourceRoot), { recursive: true }).catch(() => []);
		for (const entry of entries) {
			if (entry.endsWith(dartSuffix)) found.push(join(sourceRoot, entry));
		}
	}
	return found.sort();
}

export async function snapshot(root: string): Promise<Snapshot> {
	const files = await dartFiles(root);
	const times = await Promise.all(files.map(file => stat(join(root, file)).then(info => info.mtimeMs)));
	return new Map(files.map((file, index) => [file, times[index]]));
}

export function changedFiles(before: Snapshot, after: Snapshot): string[] {
	const changed = new Set<string>();
	for (const [file, time] of after) {
		if (before.get(file) !== time) changed.add(file);
	}
	for (const file of before.keys()) {
		if (!after.has(file)) changed.add(file);
	}
	return [...changed].sort();
}

function resolveDirective(file: string, target: string): string | undefined {
	if (target.startsWith(packagePrefix)) return join("lib", target.slice(packagePrefix.length));
	if (target.includes(":")) return undefined;
	return normalize(join(dirname(file), target));
}

export async function importGraph(root: string, files: string[]): Promise<Map<string, string[]>> {
	const sources = await Promise.all(files.map(file => readFile(join(root, file), "utf8")));
	return new Map(
		files.map((file, index) => [
			file,
			[...sources[index].matchAll(directive)].flatMap(match => resolveDirective(file, match[1]) ?? []),
		]),
	);
}

export function testsTouching(graph: Map<string, string[]>, edited: string[]): string[] {
	const wanted = new Set(edited);
	const reaches = (start: string): boolean => {
		const seen = new Set<string>();
		const queue = [start];
		while (queue.length > 0) {
			const file = queue.pop() ?? start;
			if (wanted.has(file)) return true;
			if (seen.has(file)) continue;
			seen.add(file);
			queue.push(...(graph.get(file) ?? []));
		}
		return false;
	};
	return [...graph.keys()].filter(file => file.startsWith(testRoot) && file.endsWith(testSuffix) && reaches(file));
}
