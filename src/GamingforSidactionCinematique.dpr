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
/// File last update : 2021-03-28T22:21:24.000+02:00
/// Signature : 6753a2f3ab0ab89bd45ff5c0d6a162fb9eeafe65
/// ***************************************************************************
/// </summary>

program GamingforSidactionCinematique;

uses
  System.StartUpCopy,
  FMX.Forms,
  fEcran in 'fEcran.pas' {frmEcran};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmEcran, frmEcran);
  Application.Run;
end.
