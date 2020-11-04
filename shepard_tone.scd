// A.Broz: Shepard-Risset glissando (2020-10-31)

(
/*
                 ,
                /
             `\_\
                 \
                /O\
               '   '
*/
SynthDef(\shepard, #{ |freq=440, dur=20, direction=1, amp=0.2|
	var partialCount = 9;
	var octRange = 2 ** (partialCount / 2);
	var cycle = 1 / (partialCount * dur);
	var width = if(direction >= 0, 1, 0);
	var sig = partialCount.collect { |n|
		var iphase = n / partialCount;
		var phase = (3 * pi / 2) + (2 * pi * iphase);
		var vol = SinOsc.kr(cycle, phase).range(0, 1);
		var ratio = VarSaw.kr(cycle, iphase, width).exprange(1/octRange, octRange);
		SinOsc.ar(freq * ratio) * vol;
	}.sum;
	sig = sig * amp;
	sig = sig * Line.kr(0, 1, 5); // fade in
	sig = JPverb.ar(sig!2); // reverb
	Out.ar(0, sig!2);
}).add;

~playShep = #{ |fund=300, chord=([1, 6/5, 3/2, 7/4, 9/4]), dir=(-1), dur=40, amp=0.1|
	chord.collect { |r| (
		instrument: \shepard,
		freq: fund * r,
		dur: dur,
		direction: dir,
		amp: amp,
	).play };
};
)

// falling chord
~shep = ~playShep.value;

// rising chord
~shep = ~playShep.(300, [9/16, 4/7, 3/4, 1, 4/3, 7/4, 16/9], 1, 12, 0.03);

// free all
~shep do: _.free;