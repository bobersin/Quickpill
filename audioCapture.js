import { spawn } from "node:child_process";
import { execSync } from "node:child_process";
import FFT from "fft.js";
const numBands = Number(process.argv[2]);

if (Number.isNaN(numBands)) {
	console.error("Usage: node visualizer.js <bands>");
	process.exit(1);
}

let defaultSink = execSync(
	"wpctl inspect @DEFAULT_AUDIO_SINK@ | grep 'object.serial'",
)
	.toString()
	.match(/\d+/g)[0];
const size = 2048;
const fft = new FFT(size);
const recorder = spawn("pw-record", [
	"-a",
	"--channels",
	"1",
	"--target",
	defaultSink,
	"--latency",
	"20ms",
	"-",
]);
const bands = Array.from(
	{ length: numBands },
	(_, x) => 20 * Math.pow(1000, (x + 1) / numBands),
);
const bins = bands.map((f) => Math.round((f * size) / 48000));

let lastOutput = 0;

function sendDisplay(display) {
	const now = performance.now();

	if (now - lastOutput < 30) return;

	lastOutput = now;
	console.log(JSON.stringify(display.map((v) => Math.log(v + 1))));
}

const input = new Float32Array(size);
const output = fft.createComplexArray();
recorder.stdout.on("data", (chunk) => {
	const samples = new Int16Array(
		chunk.buffer,
		chunk.byteOffset,
		chunk.byteLength / 2,
	);
	for (let i = 0; i < input.length; i++) input[i] = samples[i] / 32768;

	fft.realTransform(output, input);

	const final = new Float32Array(size / 2);

	for (let i = 0; i < size; i += 2) {
		final[i / 2] = Math.sqrt(
			output[i] * output[i] + output[i + 1] * output[i + 1],
		);
	}

	const display = bins.map((upper, i) => {
		const lower = i === 0 ? 0 : bins[i - 1];
		const slice = final.slice(lower, upper);

		if (slice.length === 0) return 0;

		return Math.sqrt(slice.reduce((sum, v) => sum + v * v, 0) / slice.length);
	});
	sendDisplay(display);
});
