unit iMotorPlato;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  teVelocidadMotor = (RPM16,RPM33,RPM45,RPM78); //No permite que comience con
  tiMotorPlato=interface
   procedure Encender(velocidad:teVelocidadMotor);
   procedure Detener;
  end;

implementation

end.

