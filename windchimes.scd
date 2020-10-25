// Windchimes demo: Buffers & Randomness

// Setup: Load some buffers & define some chords
(
var audioDir = thisProcess.nowExecutingPath.dirname +/+ "audio";

// Buffers
~buffs = PathName(audioDir).entries.collect { |p|
	p.fileNameWithoutExtension.asSymbol ->
	Buffer.read(s, p.fullPath)
}.asDict;

// Tunings
~just = [1/2, 3/5, 3/4, 7/8, 9/8]; // pretty chord
~eq5 = Array.geom(5, 1/2, 2 ** (1/5)); // equipentatonic chord
~eq7 = Array.geom(7, 1/2, 2 ** (1/7)); // roughly Javanese gamelan scale
~qt = Array.geom(6, 1/2, 2 ** (1/24)); // chromatic quarter-tone cluster
)

// Add a synth
(
SynthDef(\windchimes, {
	var bufnum = \buf.kr(~buffs[\deskBell]);
	var env = EnvGen.kr(Env.adsr(0.02, 20, 1, 20), \gate.kr(1), doneAction: 2);
	var windSpeed = LFNoise1.kr(1/30).range(\min.kr(0.05, 10), \max.kr(0.3, 10));
	var sig = \chord.kr(~just) collect: { |rate|
		PlayBuf.ar(
			numChannels: 2,
			bufnum: bufnum,
			rate: BufRateScale.ir(bufnum) * rate * \fund.kr(0.5),
			trigger: Dust.kr(windSpeed * rate.sqrt),
		)
		* LFNoise1.kr(rrand(1/10, 1/3)).exprange(0.02, windSpeed)
		* rate.sqrt
	};
	sig = LPF.ar(sig, \dampAt.kr(5000, 5));
	sig = Splay.ar(sig) * env;
	Out.ar(0, sig);
}).add;
)

// =========================

// Start the windchimes ...
w = Synth(\windchimes);


// Change params (live!)

// 1. Change the chord
w.set(\chord, ~eq5, \fund, 1); // pretty
w.set(\chord, ~eq7, \fund, 1); // nice

w.set(\chord, ~qt, \fund, 1/2); // out of tune
w.set(\chord, ~qt, \fund, 1/4); // extra creepy

w.set(\chord, ~just, \fund, 2); // high

// Favorites
w.set(\chord, ~just, \fund, 1/2); // harmonic
w.set(\chord, ~eq5, \fund, 1/2); // relaxing
// nice combo:
w.set(\chord, ~eq7, \fund, 1);
w.seti(\chord, 0, 1/8); // change bottom chime to a low gong

// 2. Make it really windy
w.set(\min, 0.8, \max, 1);

// 3. Make the wind die down
w.set(\min, 0, \max, 0.1);

// 4. Back to default
w.set(\min, 0.05, \max, 0.3);

// 5. Get weird
w.set(\buf, ~buffs[\drumloop]); // switch the buffer to a drum loop
w.set(\buf, ~buffs[\deskBell]); // enough of that


// Fade out ...
w.set(\gate, 0);