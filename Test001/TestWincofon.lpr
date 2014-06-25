program TestWincofon;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, CasosTest, IActuadorBrazo, iMotorPlato,
  iDetectorDisco, oTocadiscosIO, PascalMock;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

