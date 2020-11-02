// A.Broz: Shepard-Risset glissando demo (2020-10-31)

(
SynthDef(\shepard, #{ |freq=440, speed=40, direction=1, amp=0.2|
	var width = if(direction >= 0, 1, 0);
	var sig = (0..7).collect { |offset|
		var volPhase = (3 * pi / 2) + (offset * pi / 4);
		var vol = SinOsc.kr(1/speed, volPhase).range(0, 1).tanh;
		var ratio = VarSaw.kr(1/speed, offset / 8, width).exprange(1/16, 16);
		SinOsc.ar(freq * ratio) * vol;
	}.sum;
	sig = sig!2 * (amp/8) * Line.kr(0, 1, 5); // fade in
	Out.ar(0, sig);
}).add;

~playShep = { |fund=300, chord=([1, 5/4, 3/2]), dir=(-1), speed=400, amp=0.1|
	chord.collect { |r| (
		instrument: \shepard,
		freq: fund * r,
		speed: speed,
		direction: dir,
		amp: amp,
	).play };
};
)

// slowly falling chord
~shep = ~playShep.value;

// rising additive tone
~shep = ~playShep.(800, 1!4++(2..5), 1, 30);

// more complex falling tone
~chord = [1, 5/4, 3/2].collect { |r| (1,3..7).collect(_ * r) }.flatten;
~shep = ~playShep.(fund: 200, chord: ~chord, amp: 0.1);

// free all
~shep do: _.free;