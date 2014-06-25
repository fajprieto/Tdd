unit oTocadiscosIO;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  //Componentes
  iMotorPlato,
  iDetectorDisco,
  iActuadorBrazo
  ;

type
  tcTocadiscosIO=class
   Reproduciendo:Boolean;
   detectorDeDisco:tiDetectorDeDisco;
   motorPlato:tiMotorPlato;
   actuadorBrazo:tiActuadorBrazo;
   constructor Create(detector:tiDetectorDeDisco;motor:tiMotorPlato;actuador:tiActuadorBrazo);
   procedure IniciarReproduccion();
   procedure IniciarReproduccion(velocidad:teVelocidadMotor);
   procedure DetenerReproduccion;
   procedure CambiarVelocidad(velocidad:teVelocidadMotor);
  end;
var
  velocidad:teVelocidadMotor;

implementation

constructor tcTocadiscosIO.Create(detector:tiDetectorDeDisco;motor:tiMotorPlato;actuador:tiActuadorBrazo);
begin
  self.detectorDeDisco:=detector;
  self.motorPlato:=motor;
  self.actuadorBrazo:=actuador;
end;

procedure tcTocadiscosIO.IniciarReproduccion();
begin
  IniciarReproduccion(velocidad.RPM33);
end;

procedure tcTocadiscosIO.IniciarReproduccion(velocidad:teVelocidadMotor);
begin
  if self.detectorDeDisco.DiscoEnPosicion then
    begin
      self.motorPlato.Encender(velocidad);
      self.actuadorBrazo.Bajar();
      self.Reproduciendo:=True;
    end
  else
    self.Reproduciendo:=False;
end;

procedure tcTocadiscosIO.CambiarVelocidad(velocidad:teVelocidadMotor);
begin
  self.motorPlato.Encender(velocidad);
end;

procedure tcTocadiscosIO.DetenerReproduccion;
begin
  self.motorPlato.Detener();
  self.actuadorBrazo.Levantar();
  self.Reproduciendo:=False;
end;


end.

