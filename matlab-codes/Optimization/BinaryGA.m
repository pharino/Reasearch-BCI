%%  Binary GA Code
%       Sctipt structure: CGA

%%  Define fitness funtion

BGA.Setup.FF   = @cost1;
BGA.Setup.NPar = 2;

%%  Stop criteria
BGA.Stop.Maxit    = 100;
BGA.Stop.MaxCost  = 9999;

%%  GA parameter
BGA.Parameters.PopSize      = 16;
BGA.Parameters.MutRate      = 0.15;
BGA.Parameters.Selection    = 0.5;
BGA.Parameters.NBit         = 8;
BGA.Parameters.NChBit       = BGA.Parameters.NBit*BGA.Setup.NPar;
BGA.Parameters.Keep         = floor(BGA.Parameters.Selection*BGA.Parameters.PopSize);

%%  Create initial population
iga = 0;
BGA.


