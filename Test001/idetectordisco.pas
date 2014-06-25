unit iDetectorDisco;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  tiDetectorDeDisco=interface
   function Get_DiscoEnPosicion:Boolean;
   property DiscoEnPosicion:Boolean read Get_DiscoEnPosicion;
  end;

implementation

end.

