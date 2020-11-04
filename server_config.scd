// View devices
// For more, search "Audio device selection"
ServerOptions.devices; // all devices
ServerOptions.inDevices; // input devices
ServerOptions.outDevices; // output devices


(
// Presentation server config
s = Server.local;
s.options.outDevice = "BlackHole 2ch";
s.options.numOutputBusChannels = 2;
s.options.inDevice = "Built-in Microph";
s.options.numInputBusChannels = 2;
s.options.sampleRate = 44100;
s.options.memSize = 2 ** 20;
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
)


(
// Home server config
s = Server.local;
s.options.outDevice = "Built-in Output";
s.options.numOutputBusChannels = 2;
s.options.inDevice = "Built-in Microph";
s.options.numInputBusChannels = 2;
s.options.sampleRate = 44100;
s.options.memSize = 2 ** 20;
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;
)