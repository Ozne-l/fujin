package dev.oznel.fujin

import android.os.Handler
import android.os.Looper
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

object MediaThreads {
    private const val NETWORK_THREADS = 3
    private const val NETWORK_TIMEOUT_MS = 20_000L
    private const val TIMEOUT = "timeout"

    val io: ExecutorService = Executors.newSingleThreadExecutor()
    val main = Handler(Looper.getMainLooper())
    private val network: ExecutorService = Executors.newFixedThreadPool(NETWORK_THREADS)

    fun <T> background(work: () -> T, done: (Result<T>) -> Unit) {
        io.execute { main.post(settled(work, done)) }
    }

    fun <T> remote(work: () -> T, done: (Result<T>) -> Unit) {
        var answered = false
        val timeout = Runnable {
            if (!answered) {
                answered = true
                done(Result.failure(MediaException(MediaFailure.NETWORK_FAILED, TIMEOUT)))
            }
        }
        network.execute {
            main.postDelayed(timeout, NETWORK_TIMEOUT_MS)
            val reply = settled(work) { outcome ->
                main.removeCallbacks(timeout)
                if (!answered) {
                    answered = true
                    done(outcome)
                }
            }
            main.post(reply)
        }
    }

    private fun <T> settled(work: () -> T, done: (Result<T>) -> Unit): Runnable {
        val outcome = try {
            Result.success(work())
        } catch (error: Exception) {
            Result.failure(error)
        } catch (error: OutOfMemoryError) {
            Result.failure(error)
        }
        return Runnable { done(outcome) }
    }
}
