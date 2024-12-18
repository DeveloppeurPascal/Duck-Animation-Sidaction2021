/// <summary>
/// ***************************************************************************
///
/// Duck Journey Animation
///
/// Copyright 2021-2024 Patrick Prémartin under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://serialstreameur.fr/promenade-d-un-canard-animation-faite-avec-delphi.html
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Duck-Animation-Sidaction2021
///
/// ***************************************************************************
/// File last update : 2024-12-18T20:03:20.000+01:00
/// Signature : 1ceb186942e0154be9635d08c98b0d4766a65d8a
/// ***************************************************************************
/// </summary>

unit fEcran;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Layouts,
  FMX.Ani;

type
  TfrmEcran = class(TForm)
    Scene01_PlanDeLondres: TLayout;
    S01_plandelondres: TRectangle;
    S01_001_ZoomSurPlan: TTimer;
    S01_002_FonduAuNoir: TFloatAnimation;
    Scene02_Promenade: TLayout;
    S02_Background: TRectangle;
    S02_001_Apparition: TFloatAnimation;
    S02_Canard: TRectangle;
    S02_002_DeplaceCanard: TTimer;
    S02_OndulationCanard: TFloatAnimation;
    S02_003_DecaleBackground: TFloatAnimation;
    Scene03_Peche: TLayout;
    S03_Background: TRectangle;
    S03_Canard_VersLaDroite: TRectangle;
    S03_Canard_VersLaGauche: TRectangle;
    S03_CanardGaucheOndulation: TFloatAnimation;
    S03_CanardDroiteOndulation: TFloatAnimation;
    S03_Canard1Vers2: TTimer;
    S03_Canard2Vers3: TTimer;
    S03_Canard3Vers1: TTimer;
    S03_RemonteEtangDeLaMoitie: TFloatAnimation;
    S03_Tourbillon: TRectangle;
    S03_TourbillonImg: TBitmapListAnimation;
    S03_TourbillonMouvantY: TFloatAnimation;
    S03_TourbillonMouvantX: TFloatAnimation;
    CaptureAnimation: TTimer;
    procedure FormShow(Sender: TObject);
    procedure S01_001_ZoomSurPlanTimer(Sender: TObject);
    procedure S01_002_FonduAuNoirFinish(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure S02_002_DeplaceCanardTimer(Sender: TObject);
    procedure S02_001_ApparitionFinish(Sender: TObject);
    procedure S02_003_DecaleBackgroundFinish(Sender: TObject);
    procedure S03_Canard1Vers2Timer(Sender: TObject);
    procedure S03_Canard2Vers3Timer(Sender: TObject);
    procedure S03_Canard3Vers1Timer(Sender: TObject);
    procedure S03_RemonteEtangDeLaMoitieFinish(Sender: TObject);
    procedure CaptureAnimationTimer(Sender: TObject);
  private
    NumeroDeCapture: cardinal;
    procedure Scene01;
    procedure Scene02;
    procedure Scene03;
    procedure S03_InitCanardPosition1;
    procedure S03_InitCanardPosition2;
    procedure S03_InitCanardPosition3;
    function Sur10Chiffres(valeur: cardinal): string;
  public
  end;

var
  frmEcran: TfrmEcran;

implementation

{$R *.fmx}

uses
  System.Threading,
  System.IOUtils;

procedure TfrmEcran.CaptureAnimationTimer(Sender: TObject);
var
  bmp: tbitmap;
  DossierDesCaptures: string;
begin
  if Scene01_PlanDeLondres.Visible then
    bmp := Scene01_PlanDeLondres.makescreenshot
  else if Scene02_Promenade.Visible then
    bmp := Scene02_Promenade.makescreenshot
  else if Scene03_Peche.Visible then
    bmp := Scene03_Peche.makescreenshot
  else
    bmp := nil;
  if assigned(bmp) then
  begin
    inc(NumeroDeCapture);
    DossierDesCaptures := tpath.combine(tpath.GetDirectoryName(paramstr(0)),
      'Captures');
    if not TDirectory.Exists(DossierDesCaptures) then
      TDirectory.CreateDirectory(DossierDesCaptures);
    bmp.SaveToFile(tpath.combine(DossierDesCaptures,
      'GamingForSidaction_Animation_' + Sur10Chiffres(NumeroDeCapture)
      + '.png'));
    bmp.free;
  end;
end;

procedure TfrmEcran.FormCreate(Sender: TObject);
var
  obj: TFmxObject;
begin
  NumeroDeCapture := 0;
  for obj in children do
    if (obj is TLayout) then
      (obj as TLayout).Visible := false
    else if (obj is TTimer) then
      (obj as TTimer).enabled := false;
end;

procedure TfrmEcran.FormShow(Sender: TObject);
begin
  CaptureAnimation.enabled := false;
  // TODO : enable it to capture pictures of the animation
{$IFDEF DEBUG}
  Scene01;
  // scene02;
  // scene03;
{$ELSE}
  Scene01;
{$ENDIF}
end;

procedure TfrmEcran.S01_001_ZoomSurPlanTimer(Sender: TObject);
var
  dx, dy: single;
  wFinal, hFinal: integer;
begin
  wFinal := S01_plandelondres.Fill.Bitmap.Bitmap.Width * 5;
  hFinal := S01_plandelondres.Fill.Bitmap.Bitmap.height * 5;
  if (wFinal >= S01_plandelondres.Width) or (wFinal >= S01_plandelondres.Width)
  then
  begin
    S01_plandelondres.beginupdate;
    try
      dx := (wFinal - S01_plandelondres.Width) / 5 *
        (S01_001_ZoomSurPlan.Interval / 1000);
      if dx < 50 then
        dx := 50;
      S01_plandelondres.Width := S01_plandelondres.Width + dx;
      S01_plandelondres.Position.x := Width - S01_plandelondres.Width;

      dy := (hFinal - S01_plandelondres.height) / 5 *
        (S01_001_ZoomSurPlan.Interval / 1000);
      if dy < 50 then
        dy := 50;
      S01_plandelondres.height := S01_plandelondres.height + dy;
      S01_plandelondres.Position.y := (height - S01_plandelondres.height) / 2;
    finally
      S01_plandelondres.EndUpdate;
    end;
  end
  else
  begin
    S01_001_ZoomSurPlan.enabled := false;
    S01_002_FonduAuNoir.enabled := true;
  end;
end;

procedure TfrmEcran.S01_002_FonduAuNoirFinish(Sender: TObject);
begin
  S01_002_FonduAuNoir.enabled := false;
  Scene01_PlanDeLondres.Visible := false;
  Scene02;
end;

procedure TfrmEcran.S02_001_ApparitionFinish(Sender: TObject);
begin
  S02_OndulationCanard.enabled := true;
  S02_Canard.beginupdate;
  try
    S02_Canard.Position.x := -S02_Canard.Width - S02_Background.Position.x;
    S02_Canard.Position.y := 400 - S02_Background.Position.y;
  finally
    S02_Canard.EndUpdate;
  end;
  S02_002_DeplaceCanard.enabled := true;
end;

procedure TfrmEcran.S02_002_DeplaceCanardTimer(Sender: TObject);
var
  dx, dy, ds: single;
begin
  if (S02_Canard.Position.x < 790 - S02_Background.Position.x) or
    (S02_Canard.Position.y > 290 - S02_Background.Position.y) then
  begin
    // durée 5 secondes
    dx := (790 - S02_Canard.Width) / 5 *
      (S02_002_DeplaceCanard.Interval / 1000);
    dy := (290 - 400) / 5 * (S02_002_DeplaceCanard.Interval / 1000);
    ds := (0.4 - 1) / 5 * (S02_002_DeplaceCanard.Interval / 1000);
    S02_Canard.beginupdate;
    try
      S02_Canard.Position.x := S02_Canard.Position.x + dx;
      S02_Canard.Scale.x := S02_Canard.Scale.x + ds;
      S02_Canard.Position.y := S02_Canard.Position.y + dy;
      S02_Canard.Scale.y := S02_Canard.Scale.y + ds;
    finally
      S02_Canard.EndUpdate;
    end;
  end
  else
  begin
    S02_002_DeplaceCanard.enabled := false;
    S02_OndulationCanard.StartValue := -5;
    S02_OndulationCanard.stopValue := 5;
    S02_003_DecaleBackground.stopValue := Width - S02_Background.Width;
    S02_003_DecaleBackground.enabled := true;
  end;
end;

procedure TfrmEcran.S02_003_DecaleBackgroundFinish(Sender: TObject);
begin
  S02_003_DecaleBackground.enabled := false;
  Scene02_Promenade.Visible := false;
  Scene03;
end;

procedure TfrmEcran.S03_Canard1Vers2Timer(Sender: TObject);
var
  dx, dy, ds: single;
begin
  if (S03_Canard_VersLaDroite.Position.x < 1128) or
    (S03_Canard_VersLaDroite.Position.y > 264) then
  begin
    // durée 5 secondes
    dx := (1128 - 776) / 4 * (S03_Canard1Vers2.Interval / 1000);
    dy := (264 - 360) / 4 * (S03_Canard1Vers2.Interval / 1000);
    ds := (0.8 - 1) / 4 * (S03_Canard1Vers2.Interval / 1000);
    S03_Canard_VersLaDroite.beginupdate;
    try
      S03_Canard_VersLaDroite.Position.x :=
        S03_Canard_VersLaDroite.Position.x + dx;
      S03_Canard_VersLaDroite.Scale.x := S03_Canard_VersLaDroite.Scale.x + ds;
      S03_Canard_VersLaDroite.Position.y :=
        S03_Canard_VersLaDroite.Position.y + dy;
      S03_Canard_VersLaDroite.Scale.y := S03_Canard_VersLaDroite.Scale.y + ds;
    finally
      S03_Canard_VersLaDroite.EndUpdate;
    end;
  end
  else
  begin
    S03_Canard1Vers2.enabled := false;
    S03_InitCanardPosition2;
  end;
end;

procedure TfrmEcran.S03_Canard2Vers3Timer(Sender: TObject);
var
  dx, dy, ds: single;
begin
  if (S03_Canard_VersLaGauche.Position.x > 656) or
    (S03_Canard_VersLaGauche.Position.y > 248) then
  begin
    // durée 5 secondes
    dx := (656 - 1128) / 5 * (S03_Canard2Vers3.Interval / 1000);
    dy := (248 - 264) / 5 * (S03_Canard2Vers3.Interval / 1000);
    ds := (0.4 - 0.8) / 5 * (S03_Canard2Vers3.Interval / 1000);
    S03_Canard_VersLaGauche.beginupdate;
    try
      S03_Canard_VersLaGauche.Position.x :=
        S03_Canard_VersLaGauche.Position.x + dx;
      S03_Canard_VersLaGauche.Scale.x := S03_Canard_VersLaGauche.Scale.x + ds;
      S03_Canard_VersLaGauche.Position.y :=
        S03_Canard_VersLaGauche.Position.y + dy;
      S03_Canard_VersLaGauche.Scale.y := S03_Canard_VersLaGauche.Scale.y + ds;
    finally
      S03_Canard_VersLaGauche.EndUpdate;
    end;
  end
  else
  begin
    S03_Canard2Vers3.enabled := false;
    S03_InitCanardPosition3;
  end;
end;

procedure TfrmEcran.S03_Canard3Vers1Timer(Sender: TObject);
var
  dx, dy, ds: single;
begin
  if (S03_Canard_VersLaDroite.Position.x < 776) or
    (S03_Canard_VersLaDroite.Position.y < 360) then
  begin
    // durée 5 secondes
    dx := (776 - 656) / 10 * (S03_Canard1Vers2.Interval / 1000);
    dy := (360 - 248) / 10 * (S03_Canard1Vers2.Interval / 1000);
    ds := (1 - 0.4) / 10 * (S03_Canard1Vers2.Interval / 1000);
    S03_Canard_VersLaDroite.beginupdate;
    try
      S03_Canard_VersLaDroite.Position.x :=
        S03_Canard_VersLaDroite.Position.x + dx;
      S03_Canard_VersLaDroite.Scale.x := S03_Canard_VersLaDroite.Scale.x + ds;
      S03_Canard_VersLaDroite.Position.y :=
        S03_Canard_VersLaDroite.Position.y + dy;
      S03_Canard_VersLaDroite.Scale.y := S03_Canard_VersLaDroite.Scale.y + ds;
    finally
      S03_Canard_VersLaDroite.EndUpdate;
    end;
  end
  else
  begin
    S03_Canard3Vers1.enabled := false;
    S03_InitCanardPosition1;
    // Si premier passage, on déclenche la rémontée de l'écran pour voir sous l'eau
    if (S03_Canard_VersLaDroite.tag = 0) then
    begin
      S03_Canard_VersLaDroite.tag := 1;
      S03_RemonteEtangDeLaMoitie.StartValue := S03_Background.Position.y;
      // S03_RemonteEtangDeLaMoitie.stopValue :=(height - S03_Background.height)*2 / 3;
      S03_RemonteEtangDeLaMoitie.stopValue := (height - S03_Background.height);
      S03_RemonteEtangDeLaMoitie.enabled := true;
    end;
  end;
end;

procedure TfrmEcran.Scene01;
begin
  Scene01_PlanDeLondres.Visible := true;
  S01_001_ZoomSurPlan.enabled := true;
end;

procedure TfrmEcran.Scene02;
begin
  Scene02_Promenade.Visible := true;
  S02_001_Apparition.enabled := true;
end;

procedure TfrmEcran.Scene03;
begin
  Scene03_Peche.Visible := true;
  S03_InitCanardPosition1;
  S03_TourbillonImg.enabled := true;
  S03_TourbillonMouvantX.enabled := true;
  S03_TourbillonMouvantY.enabled := true;
end;

function TfrmEcran.Sur10Chiffres(valeur: cardinal): string;
begin
  result := valeur.ToString;
  while (result.Length < 10) do
    result := '0' + result;
end;

procedure TfrmEcran.S03_InitCanardPosition1;
begin
  S03_CanardGaucheOndulation.enabled := false;
  S03_Canard_VersLaGauche.Visible := false;
  S03_Canard_VersLaDroite.beginupdate;
  try
    S03_Canard_VersLaDroite.Position.x := 776;
    S03_Canard_VersLaDroite.Position.y := 360;
    S03_Canard_VersLaDroite.Scale.x := 1;
    S03_Canard_VersLaDroite.Scale.y := 1;
    S03_Canard_VersLaDroite.Visible := true;
    S03_CanardDroiteOndulation.StartValue := -20;
    S03_CanardDroiteOndulation.stopValue := -25;
    S03_CanardDroiteOndulation.enabled := true;
  finally
    S03_Canard_VersLaDroite.EndUpdate;
  end;
  S03_Canard1Vers2.enabled := true;
end;

procedure TfrmEcran.S03_InitCanardPosition2;
begin
  S03_CanardDroiteOndulation.enabled := false;
  S03_Canard_VersLaDroite.Visible := false;
  S03_Canard_VersLaGauche.beginupdate;
  try
    S03_Canard_VersLaGauche.Position.x := 1128;
    S03_Canard_VersLaGauche.Position.y := 264;
    S03_Canard_VersLaGauche.Scale.x := 0.8;
    S03_Canard_VersLaGauche.Scale.y := 0.8;
    S03_Canard_VersLaGauche.Visible := true;
    S03_CanardGaucheOndulation.StartValue := -3;
    S03_CanardGaucheOndulation.stopValue := 8;
    S03_CanardGaucheOndulation.enabled := true;
  finally
    S03_Canard_VersLaGauche.EndUpdate;
  end;
  S03_Canard2Vers3.enabled := true;
end;

procedure TfrmEcran.S03_InitCanardPosition3;
begin
  S03_CanardGaucheOndulation.enabled := false;
  S03_Canard_VersLaGauche.Visible := false;
  S03_Canard_VersLaDroite.beginupdate;
  try
    S03_Canard_VersLaDroite.Position.x := 656;
    S03_Canard_VersLaDroite.Position.y := 248;
    S03_Canard_VersLaDroite.Scale.x := 0.4;
    S03_Canard_VersLaDroite.Scale.y := 0.4;
    S03_Canard_VersLaDroite.Visible := true;
    S03_CanardDroiteOndulation.StartValue := 10;
    S03_CanardDroiteOndulation.stopValue := 15;
    S03_CanardDroiteOndulation.enabled := true;
  finally
    S03_Canard_VersLaDroite.EndUpdate;
  end;
  S03_Canard3Vers1.enabled := true;
end;

procedure TfrmEcran.S03_RemonteEtangDeLaMoitieFinish(Sender: TObject);
begin
  S03_RemonteEtangDeLaMoitie.enabled := false;
  ttask.run(
    procedure
    var
      i: integer;
    begin
      for i := 1 to 60 do
      begin
        sleep(100);
        if tthread.CheckTerminated then
          exit;
      end;
      if not tthread.CheckTerminated then
        tthread.ForceQueue(nil,
          procedure
          begin
            S03_RemonteEtangDeLaMoitie.Inverse :=
              not S03_RemonteEtangDeLaMoitie.Inverse;
            S03_RemonteEtangDeLaMoitie.enabled := true;
          end);
    end);
end;

end.
