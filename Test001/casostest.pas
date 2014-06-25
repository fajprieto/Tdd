unit CasosTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  // FpcUnit
  fpcunit, testregistry,
  // Pascal Mock
  PascalMock,
  //Componentes
  oTocadiscosIO,
  IDetectorDisco,
  IMotorPlato,
  IActuadorBrazo
  ;

type

  TestWincofon= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ReproduceCuandoEncendemos;
    procedure NoReproduceCuandoDetenemos;
    procedure NoReproduceCuandoNoHayDisco;
    procedure NoReproduceCuandoApagamos;
    procedure ReproduceEn78Rpm;
    procedure PasarA78MientrasReproduce;
    procedure BajaBrazoEnReproduccion;
    procedure SubeBrazoCuandoDetiene;
  end;

  {Objeto Mock para tiDetectorDeDisco}
  toDetectorDeDiscoMock = class(TMock,tiDetectorDeDisco)
  public
    function Get_DiscoEnPosicion:Boolean;
    property DiscoEnPosicion:Boolean read Get_DiscoEnPosicion;
  end;

  {Objeto Mock para tiMotorPlato}
  toMotorPlatoMock=class(TMock,tiMotorPlato)
  public
    procedure Encender(velocidad:teVelocidadMotor);
    procedure Detener;
  end;

  {Objeto Mock para tiActuadorBrazo}
  toActuadorBrazoMock=class(TMock,tiActuadorBrazo)
  public
    procedure Bajar;
    procedure Levantar;
  end;


var
  td:tcTocadiscosIO;
  detectorDeDisco:toDetectorDeDiscoMock;
  motorPlato:toMotorPlatoMock;
  velocidad:teVelocidadMotor;
  actuadorBrazo:toActuadorBrazoMock;

implementation

function toDetectorDeDiscoMock.Get_DiscoEnPosicion:Boolean;
begin
  // mock object call AddCall() with the method signature and retrieve return value
  Result := AddCall('Get_DiscoEnPosicion').ReturnValue;
end;

procedure toMotorPlatoMock.Encender(velocidad:teVelocidadMotor);
begin
  AddCall('Encender').WithParams([velocidad]);
end;

procedure toMotorPlatoMock.Detener;
begin
  AddCall('Detener');
end;

procedure toActuadorBrazoMock.Bajar;
begin
  AddCall('Bajar');
end;

procedure toActuadorBrazoMock.Levantar;
begin
  AddCall('Levantar');
end;

procedure TestWincofon.ReproduceCuandoEncendemos;
begin
  detectorDeDisco.Expects('Get_DiscoEnPosicion').Returns(True);
  motorPlato.Expects('Encender').WithParams([velocidad.RPM33]); //Se espera que arranque el motor
  td.IniciarReproduccion();
  AssertEquals('El tocadiscos debe estar reproduciendo.',td.Reproduciendo,True);
  motorPlato.Verify('El motor no fue encendido nunca'); //Se verifica si se llamo a Encender motor
end;

procedure TestWincofon.NoReproduceCuandoDetenemos;
begin
  detectorDeDisco.Expects('Get_DiscoEnPosicion').Returns(True);
  td.IniciarReproduccion();
  td.DetenerReproduccion;
  AssertEquals('El tocadiscos no debería estar reproduciendo.',td.Reproduciendo,False);
end;

procedure TestWincofon.NoReproduceCuandoNoHayDisco;
begin
  detectorDeDisco.Expects('Get_DiscoEnPosicion').Returns(False);
  motorPlato.Expects('Encender',0).WithParams([velocidad.RPM33]);
  td.IniciarReproduccion();
  AssertEquals('El tocadiscos no debería estar reproduciendo.',td.Reproduciendo,False);
end;

procedure TestWincofon.NoReproduceCuandoApagamos;
begin
  detectorDeDisco.Expects('Get_DiscoEnPosicion').Returns(True);
  motorPlato.Expects('Encender').WithParams([velocidad.RPM33]);
  motorPlato.Expects('Detener');
  td.IniciarReproduccion();
  td.DetenerReproduccion;
  motorPlato.Verify();
end;

procedure TestWincofon.ReproduceEn78Rpm;
begin
  detectorDeDisco.Expects('Get_DiscoEnPosicion').Returns(True);
  motorPlato.Expects('Encender').WithParams([velocidad.RPM78]);
  td.IniciarReproduccion(velocidad.RPM78);
  AssertEquals('El tocadiscos debe estar reproduciendo.',td.Reproduciendo,True);
  motorPlato.Verify('El motor no fue encendido en 78');
end;

procedure TestWincofon.PasarA78MientrasReproduce;
begin
  detectorDeDisco.Expects('Get_DiscoEnPosicion').Returns(True);
  motorPlato.Expects('Encender').WithParams([velocidad.RPM33]);
  motorPlato.Expects('Encender').WithParams([velocidad.RPM78]);
  td.IniciarReproduccion(velocidad.RPM33);
  td.CambiarVelocidad(velocidad.RPM78);
  motorPlato.Verify('El motor no fue encendido o no cambio a velocidad 78');
end;

procedure TestWincofon.BajaBrazoEnReproduccion;
begin
  detectorDeDisco.Expects('Get_DiscoEnPosicion').Returns(True);
  actuadorBrazo.Expects('Bajar');
  td.IniciarReproduccion(velocidad.RPM33);
  actuadorBrazo.Verify('El actuador brazo no fue llamado');
end;

procedure TestWincofon.SubeBrazoCuandoDetiene;
begin
  actuadorBrazo.Expects('Levantar');
  td.DetenerReproduccion();
  actuadorBrazo.Verify('El actuador brazo no fue llamado');
end;

procedure TestWincofon.SetUp;
begin
  detectorDeDisco:=toDetectorDeDiscoMock.Create;
  motorPlato:=toMotorPlatoMock.Create;
  actuadorBrazo:=toActuadorBrazoMock.Create;
  td:=tcTocadiscosIO.Create(detectorDeDisco,motorPlato,actuadorBrazo);
end;

procedure TestWincofon.TearDown;
begin

end;

initialization

  RegisterTest(TestWincofon);
end.

