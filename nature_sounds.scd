// Waves: Subtractive Synthesis

/*
           _.====.._
         ,:._       ~-_
             `\        ~-_
               | _  _  |  `.
             ,/ /_)/ | |    ~-_
    -..__..-''  \_ \_\ `_      ~~--..__...----...
*/
(
~waves = {
	var noise = { WhiteNoise.ar(0.04 + LFNoise1.kr(0.3, 0.03)) };
	var motion = { LFNoise1.kr(0.2).exprange(100, 2000) };
	var hps = { HPF.ar(noise.value, 50) };
	var wave = { LPF.ar(hps.value, motion.value).tanh };
	var sig = Splay.ar(wave!20, 0.6).tanh;
	sig = sig * Line.kr(0, 1, 10); // fade in
	LeakDC.ar(sig);
}.play;
)

~waves release: 10;