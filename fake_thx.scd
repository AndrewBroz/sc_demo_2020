// A. Broz: Deep Choir (v2, 2020-10-29)
(
~numVoices = 30;

~chaos = { |range = 1.0|
	~numVoices collect: { exprand(180 / range, 260 * range) }
};

~bigChord = { |fund = 30, harmonics = 5|
	~numVoices collect: {
		fund
		* rrand(1, harmonics) // build chord
		* rrand(1, 2) * rrand(1, 2) // octaves
		+ rrand(-1.2, 1.2) // beats
	}
};

// Try with Pmono
SynthDef(\fakeTHX, {
	var env = EnvGen.kr(
		envelope: Env.adsr(15, \decay.kr(10), 1, 10, curve: \sine),
		gate: \gate.kr(1),
		doneAction: Done.freeSelf,
	);
	var chord = \freq.kr(~chaos.value, \lag.kr(10));
	var meander = \meander.kr(0.3, 8);
	var sig = chord collect: { |f|
		f = f * LFNoise2.kr(rrand(0.3, 0.8)).exprange(1 - meander, 1 + meander);
		BLowPass.ar(Saw.ar(f), f, 0.6);
	};
	sig = Splay.ar(sig, 0.8) * env * \mul.kr(0.5, 3);
	Out.ar(0, sig);
}).add;
)

(
Routine({
	var fakeTHX = Synth(\fakeTHX);

	10.wait;

	fakeTHX.set(\meander, 0);

	fakeTHX.set(\freq, ~bigChord.(30, 5));

	10.wait;

	fakeTHX.set(\gate, 0);
}).play;
)