unit Model.Util;

interface

uses
  System.SysUtils;

  function RemoveAcento( aValue : String) : string;
  function Capitaliza( aValue : String; Captalizar, RemoveCaracter : Boolean) : string;

implementation

function Capitaliza( aValue : String; Captalizar, RemoveCaracter : Boolean) : string;
var
  flag: Boolean;
  i: Byte;
  t: string;
begin
  t := aValue;
  if Captalizar then
  begin
    flag := True;
    aValue := AnsiLowerCase(aValue);
    t := EmptyStr;
    for i := 1 to Length(aValue) do
    begin
      if flag then
        t := t + AnsiUpperCase(aValue[i])
      else
        t := t + aValue[i];
      flag := (CharInSet(aValue[i],[' ','_','-', '[',']', '(', ')']));
    end;
  end;
  if RemoveCaracter then
    t := t.Replace(' ','')
          .Replace('_','')
          .Replace('-','')
          .Replace(',','')
          .Replace(', ','');

  Result := t;
end;

function RemoveAcento(aValue: String): string;
var
  i : integer;
  aux : string;
begin
  aux := AnsiUpperCase(aValue);
    for i := 1 to length(aux) do
    begin
      case aux[i] of
      'Á', 'Â', 'Ã', 'À', 'Ä', 'á', 'â', 'ã', 'à', 'ä': aux[i] := 'A';
      'É', 'Ê', 'È', 'Ë', 'é', 'ê', 'è', 'ë', '&': aux[i] := 'E';
      'Í', 'Î', 'Ì', 'Ï', 'í', 'î', 'ì', 'ï': aux[i] := 'I';
      'Ó', 'Ô', 'Õ', 'Ò', 'Ö', 'ó', 'ô', 'õ', 'ò', 'ö': aux[i] := 'O';
      'Ú', 'Û', 'Ù', 'Ü', 'ú', 'û', 'ù', 'ü': aux[i] := 'U';
      'Ç', 'ç': aux[i] := 'C';
      'Ñ', 'ñ': aux[i] := 'N';
      'İ', 'ı': aux[i] := 'Y';
      else
        if ord(aux[i]) > 127 then
          aux[i] := #32;
      end;
    end;
  Result := aux;
end;

end.
