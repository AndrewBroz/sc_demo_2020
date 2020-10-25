// Subtractive waves
(
{
	var noiseF, hpsF, motionF, waveF, sig;
	noiseF = { WhiteNoise.ar(0.04 + LFNoise1.kr(0.3, 0.03)) };
	hpsF = { HPF.ar(noiseF.value, 50) };
	motionF = { LFNoise1.kr(0.2).exprange(100, 2000) };
	waveF = { LPF.ar(hps.value, motion.value).tanh };
	sig = waveF!10;
	sig = Splay.ar(sig, 0.6).tanh;
	sig = sig * Line.kr(0, 1, 10);
	sig = LeakDC.ar(sig);
}.play;
)