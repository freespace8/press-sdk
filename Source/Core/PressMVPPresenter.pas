(*
  PressObjects, MVP-Presenter Classes
  Copyright (C) 2006 Laserpress Ltda.

  http://www.pressobjects.org

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
*)

unit PressMVPPresenter;

interface

{$I Press.inc}

uses
  Classes,
  Controls,
  Graphics,
  Grids,
  Forms,
  PressCompatibility,
  PressClasses,
  PressSubject,
  PressNotifier,
  PressMVP,
  PressMVPModel,
  PressMVPView;

type
  TPressMVPValuePresenter = class;
  TPressMVPItemPresenter = class;
  TPressMVPItemsPresenter = class;
  TPressMVPFormPresenter = class;

  { TPressMVPInteractors }

  TPressMVPNextControlInteractor = class(TPressMVPInteractor)
  protected
    procedure DoPressEnter; virtual;
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  TPressMVPUpdateComboInteractor = class(TPressMVPNextControlInteractor)
  private
    function GetOwner: TPressMVPItemPresenter;
    function GetView: TPressMVPComboBoxView;
  protected
    procedure DoPressEnter; override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
    property Owner: TPressMVPItemPresenter read GetOwner;
    property View: TPressMVPComboBoxView read GetView;
  end;

  TPressMVPOpenComboInteractor = class(TPressMVPInteractor)
  private
    function GetOwner: TPressMVPItemPresenter;
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
    property Owner: TPressMVPItemPresenter read GetOwner;
  end;

  TPressMVPChangeModelInteractor = class(TPressMVPInteractor)
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  TPressMVPExitUpdatableInteractor = class(TPressMVPInteractor)
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  TPressMVPClickUpdatableInteractor = class(TPressMVPInteractor)
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  TPressMVPDblClickSelectableInteractor = class(TPressMVPInteractor)
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  TPressMVPEditableInteractor = class(TPressMVPInteractor)
  private
    function GetOwner: TPressMVPValuePresenter;
  protected
    procedure InitInteractor; override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
    property Owner: TPressMVPValuePresenter read GetOwner;
  end;

  TPressMVPNumericInteractor = class(TPressMVPEditableInteractor)
  private
    FAcceptDecimal: Boolean;
    FAcceptNegative: Boolean;
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
    property AcceptDecimal: Boolean read FAcceptDecimal write FAcceptDecimal;
    property AcceptNegative: Boolean read FAcceptNegative write FAcceptNegative;
  end;

  TPressMVPIntegerInteractor = class(TPressMVPNumericInteractor)
  protected
    procedure InitInteractor; override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  TPressMVPFloatInteractor = class(TPressMVPNumericInteractor)
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  TPressMVPDateTimeInteractor = class(TPressMVPEditableInteractor)
  protected
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  TPressMVPDrawGridInteractor = class(TPressMVPInteractor)
  private
    function GetOwner: TPressMVPItemsPresenter;
  protected
    procedure DrawCell(Sender: TPressMVPGridView; ACanvas: TCanvas; ACol, ARow: Longint; ARect: TRect; State: TGridDrawState); virtual;
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
    property Owner: TPressMVPItemsPresenter read GetOwner;
  end;

  TPressMVPSelectGridInteractor = class(TPressMVPInteractor)
  private
    function GetOwner: TPressMVPItemsPresenter;
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
    procedure SelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean); virtual;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
    property Owner: TPressMVPItemsPresenter read GetOwner;
  end;

  TPressMVPCreateFormInteractor = class(TPressMVPInteractor)
  private
    function GetModel: TPressMVPStructureModel;
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
    property Model: TPressMVPStructureModel read GetModel;
  end;

  TPressMVPCloseFormInteractor = class(TPressMVPInteractor)
  private
    function GetOwner: TPressMVPFormPresenter;
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
    property Owner: TPressMVPFormPresenter read GetOwner;
  end;

  TPressMVPFreePresenterInteractor = class(TPressMVPInteractor)
  protected
    procedure InitInteractor; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    class function Apply(APresenter: TPressMVPPresenter): Boolean; override;
  end;

  { TPressMVPPresenters }

  TPressMVPValuePresenter = class(TPressMVPPresenter)
  private
    function GetModel: TPressMVPValueModel;
    function GetView: TPressMVPAttributeView;
  protected
    procedure InternalUpdateModel; override;
    procedure InternalUpdateView; override;
  public
    class function Apply(AModel: TPressMVPModel; AView: TPressMVPView): Boolean; override;
    property Model: TPressMVPValueModel read GetModel;
    property View: TPressMVPAttributeView read GetView;
  end;

  TPressMVPItemPresenter = class(TPressMVPPresenter)
  private
    FDisplayNames: string;
    FDisplayNameList: TStrings;
    function DisplayValueAttribute: TPressValue;
    function GetDisplayNameList: TStrings;
    function GetModel: TPressMVPReferenceModel;
    function GetView: TPressMVPItemView;
    procedure SetDisplayNames(const Value: string);
  protected
    procedure InternalUpdateModel; override;
    procedure InternalUpdateView; override;
    property DisplayNameList: TStrings read GetDisplayNameList;
  public
    destructor Destroy; override;
    class function Apply(AModel: TPressMVPModel; AView: TPressMVPView): Boolean; override;
    procedure UpdateReferences(const ASearchString: string);
    property DisplayNames: string read FDisplayNames write SetDisplayNames;
    property Model: TPressMVPReferenceModel read GetModel;
    property View: TPressMVPItemView read GetView;
  end;

  TPressMVPItemsPresenter = class(TPressMVPPresenter)
  private
    FDisplayNames: string;
    FDisplayNameList: TStrings;
    function GetDisplayNameList: TStrings;
    function GetModel: TPressMVPItemsModel;
    function GetView: TPressMVPItemsView;
    procedure ParseDisplayNameList;
    procedure SetDisplayNames(const Value: string);
  protected
    procedure InternalUpdateModel; override;
    procedure InternalUpdateView; override;
    property DisplayNameList: TStrings read GetDisplayNameList;
  public
    destructor Destroy; override;
    class function Apply(AModel: TPressMVPModel; AView: TPressMVPView): Boolean; override;
    function DisplayHeader(ACol: Integer): string;
    function HeaderAlignment(ACol: Integer): TAlignment;
    property DisplayNames: string read FDisplayNames write SetDisplayNames;
    property Model: TPressMVPItemsModel read GetModel;
    property View: TPressMVPItemsView read GetView;
  end;

  TPressMVPFormPresenterClass = class of TPressMVPFormPresenter;

  TPressMVPFormPresenter = class(TPressMVPPresenter)
  private
    FAutoDestroy: Boolean;
    FOwnedCommandList: TPressMVPCommandList;
    FQueryPresenter: TPressMVPItemsPresenter;
    function ComponentByName(const AComponentName: ShortString): TComponent;
    function ControlByName(const AControlName: ShortString): TControl;
    function GetView: TPressMVPFormView;
    function GetModel: TPressMVPObjectModel;
    function GetOwnedCommandList: TPressMVPCommandList;
  protected
    function AttributeByName(const AAttributeName: ShortString): TPressAttribute;
    procedure BindCommand(ACommandClass: TPressMVPCommandClass; const AComponentName: ShortString);
    procedure CreateQueryPresenter(const AControlName: ShortString);
    function CreateSubPresenter(const AAttributeName, AControlName: ShortString; const ADisplayNames: string = ''): TPressMVPPresenter;
    procedure EditQueryPresenter(const ADisplayNames: string);
    procedure InitPresenter; override;
    procedure InternalUpdateModel; override;
    procedure InternalUpdateView; override;
    property OwnedCommandList: TPressMVPCommandList read GetOwnedCommandList;
  public
    destructor Destroy; override;
    class function Apply(AModel: TPressMVPModel; AView: TPressMVPView): Boolean; override;
    class procedure RegisterFormPresenter(AObjectClass: TPressObjectClass; AFormClass: TFormClass);
    class function Run(AObject: TPressObject = nil; AIncluding: Boolean = False; AAutoDestroy: Boolean = True): TPressMVPFormPresenter; overload;
    class function Run(AOwner: TPressMVPPresenter; AObject: TPressObject = nil; AIncluding: Boolean = False; AAutoDestroy: Boolean = True): TPressMVPFormPresenter; overload;
    property AutoDestroy: Boolean read FAutoDestroy;
    property Model: TPressMVPObjectModel read GetModel;
    property View: TPressMVPFormView read GetView;
  end;

  TPressMVPMainFormPresenterClass = class of TPressMVPMainFormPresenter;

  TPressMVPMainFormPresenter = class(TPressMVPFormPresenter)
  private
    FOnIdle: TIdleEvent;
  protected
    procedure Idle(Sender: TObject; var Done: Boolean);
    procedure InitPresenter; override;
    function InternalCreateModel: TPressMVPModel; virtual;
    function InternalCreateView: TPressMVPFormView; virtual;
  public
    constructor Create; reintroduce; virtual;
    procedure ShutDown;
  end;

  TPressMVPRegisteredForm = class(TObject)
  private
    FFormClass: TFormClass;
    FObjectClass: TPressObjectClass;
    FPresenterClass: TPressMVPFormPresenterClass;
  public
    constructor Create(APresenterClass: TPressMVPFormPresenterClass; AObjectClass: TPressObjectClass; AFormClass: TFormClass);
    property FormClass: TFormClass read FFormClass;
    property ObjectClass: TPressObjectClass read FObjectClass;
    property PresenterClass: TPressMVPFormPresenterClass read FPresenterClass;
  end;

  TPressMVPRegisteredFormIterator = class;

  TPressMVPRegisteredFormList = class(TPressList)
  private
    function GetItems(AIndex: Integer): TPressMVPRegisteredForm;
    procedure SetItems(AIndex: Integer; const Value: TPressMVPRegisteredForm);
  protected
    function InternalCreateIterator: TPressCustomIterator; override;
  public
    function Add(AObject: TPressMVPRegisteredForm): Integer;
    function CreateIterator: TPressMVPRegisteredFormIterator;
    function IndexOf(AObject: TPressMVPRegisteredForm): Integer;
    function IndexOfObjectClass(AObjectClass: TPressObjectClass): Integer;
    function IndexOfPresenterClass(APresenterClass: TPressMVPFormPresenterClass): Integer;
    procedure Insert(Index: Integer; AObject: TPressMVPRegisteredForm);
    function Remove(AObject: TPressMVPRegisteredForm): Integer;
    property Items[AIndex: Integer]: TPressMVPRegisteredForm read GetItems write SetItems; default;
  end;

  TPressMVPRegisteredFormIterator = class(TPressIterator)
  private
    function GetCurrentItem: TPressMVPRegisteredForm;
  public
    property CurrentItem: TPressMVPRegisteredForm read GetCurrentItem;
  end;

procedure PressAssignMainPresenterClass(APresenterClass: TPressMVPMainFormPresenterClass);
procedure PressInitMainPresenter;
function PressMainPresenter: TPressMVPMainFormPresenter;
function PressMainPresenterClass: TPressMVPMainFormPresenterClass;

implementation

uses
  SysUtils,
  {$IFDEF PressLog}PressLog,{$ENDIF}
  PressConsts,
  PressMVPCommand;

var
  _PressMVPMainPresenterClass: TPressMVPMainFormPresenterClass;
  _PressMVPMainPresenter: TPressMVPMainFormPresenter;
  _PressMVPRegisteredForms: TPressMVPRegisteredFormList;

procedure PressAssignMainPresenterClass(APresenterClass: TPressMVPMainFormPresenterClass);
begin
  if Assigned(_PressMVPMainPresenter) then
    raise EPressError.Create(SMainPresenterIsInitialized);
  if Assigned(_PressMVPMainPresenterClass) then
    raise EPressError.Create(SMainPresenterClassIsAssigned);
  _PressMVPMainPresenterClass := APresenterClass;
end;

procedure PressInitMainPresenter;
begin
  PressMainPresenter;
end;

function PressMainPresenter: TPressMVPMainFormPresenter;
begin
  if not Assigned(_PressMVPMainPresenter) then
    _PressMVPMainPresenter := PressMainPresenterClass.Create;
  Result := _PressMVPMainPresenter;
end;

function PressMainPresenterClass: TPressMVPMainFormPresenterClass;
begin
  if not Assigned(_PressMVPMainPresenterClass) then
    _PressMVPMainPresenterClass := TPressMVPMainFormPresenter;
  Result := _PressMVPMainPresenterClass;
end;

function PressMVPRegisteredForms: TPressMVPRegisteredFormList;
begin
  if not Assigned(_PressMVPRegisteredForms) then
  begin
    _PressMVPRegisteredForms := TPressMVPRegisteredFormList.Create(True);
    PressRegisterSingleObject(_PressMVPRegisteredForms);
  end;
  Result := _PressMVPRegisteredForms;
end;

{ TPressMVPNextControlInteractor }

class function TPressMVPNextControlInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter.View is TPressMVPWinView;
end;

procedure TPressMVPNextControlInteractor.DoPressEnter;
begin
  if Owner.View is TPressMVPWinView then
    TPressMVPWinView(Owner.View).SelectNext;
end;

procedure TPressMVPNextControlInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewKeyPressEvent]);
end;

procedure TPressMVPNextControlInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  if (AEvent is TPressMVPViewKeyPressEvent) and
   (TPressMVPViewKeyPressEvent(AEvent).Key = #13) then
  begin
    DoPressEnter;
    TPressMVPViewKeyPressEvent(AEvent).Key := #0;
  end;
end;

{ TPressMVPUpdateComboInteractor }

class function TPressMVPUpdateComboInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := (APresenter is TPressMVPItemPresenter) and
   (APresenter.View is TPressMVPComboBoxView);
end;

procedure TPressMVPUpdateComboInteractor.DoPressEnter;
begin
  if (Owner.View.AsString = '') or
   (View.DroppedDown and (View.CurrentItem >= 0)) then
    inherited
  else if View.Changed then
  begin
    Owner.UpdateReferences(Owner.View.AsString);
    if Owner.Model.Query.Count = 1 then
      inherited
    else
      View.ShowReferences;
  end else
    inherited;
end;

function TPressMVPUpdateComboInteractor.GetOwner: TPressMVPItemPresenter;
begin
  Result := inherited Owner as TPressMVPItemPresenter;
end;

function TPressMVPUpdateComboInteractor.GetView: TPressMVPComboBoxView;
begin
  Result := inherited Owner.View as TPressMVPComboBoxView;
end;

{ TPressMVPOpenComboInteractor }

class function TPressMVPOpenComboInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter is TPressMVPItemPresenter;
end;

function TPressMVPOpenComboInteractor.GetOwner: TPressMVPItemPresenter;
begin
  Result := inherited Owner as TPressMVPItemPresenter;
end;

procedure TPressMVPOpenComboInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewDropDownEvent]);
end;

procedure TPressMVPOpenComboInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  Owner.UpdateReferences('');
end;

{ TPressMVPChangeModelInteractor }

class function TPressMVPChangeModelInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter.View is TPressMVPWinView;
end;

procedure TPressMVPChangeModelInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewEnterEvent]);
end;

procedure TPressMVPChangeModelInteractor.Notify(AEvent: TPressEvent);
var
  VPresenter: TPressMVPPresenter;
begin
  inherited;
  VPresenter := Owner;
  while Assigned(VPresenter) and not (VPresenter is TPressMVPFormPresenter) do
    VPresenter := VPresenter.Parent;
  { TODO : "ParentForm: TPressMVPFormPresenter" property }
  if VPresenter is TPressMVPFormPresenter then
  begin
    TPressMVPFormPresenter(VPresenter).Model.SelectModel(Owner.Model);
    Owner.UpdateView;
  end;
end;

{ TPressMVPExitUpdatableInteractor }

class function TPressMVPExitUpdatableInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := (APresenter is TPressMVPValuePresenter) or
   (APresenter is TPressMVPItemPresenter);
end;

procedure TPressMVPExitUpdatableInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewExitEvent]);
  Notifier.AddNotificationItem(Owner.Model, [TPressMVPModelUpdateDataEvent]);
end;

procedure TPressMVPExitUpdatableInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  try
    Owner.UpdateModel;
    Owner.UpdateView;
  except
    if Owner.View is TPressMVPWinView then
    begin
      Owner.View.DisableEvents;
      try
        TPressMVPWinView(Owner.View).SetFocus;
      finally
        Owner.View.EnableEvents;
      end;
    end;
    raise;
  end;
end;

{ TPressMVPClickUpdatableInteractor }

class function TPressMVPClickUpdatableInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter.View is TPressMVPCheckBoxView;
end;

procedure TPressMVPClickUpdatableInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewClickEvent]);
end;

procedure TPressMVPClickUpdatableInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  Owner.UpdateModel;
end;

{ TPressMVPDblClickSelectableInteractor }

class function TPressMVPDblClickSelectableInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter is TPressMVPItemsPresenter;
end;

procedure TPressMVPDblClickSelectableInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewDblClickEvent]);
end;

procedure TPressMVPDblClickSelectableInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  TPressMVPModelCreateFormEvent.Create(Owner.Model).Notify;
end;

{ TPressMVPEditableInteractor }

class function TPressMVPEditableInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter is TPressMVPValuePresenter;
end;

function TPressMVPEditableInteractor.GetOwner: TPressMVPValuePresenter;
begin
  Result := inherited Owner as TPressMVPValuePresenter;
end;

procedure TPressMVPEditableInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewKeyPressEvent]);
end;

{ TPressMVPNumericInteractor }

procedure TPressMVPNumericInteractor.InitInteractor;
begin
  inherited;
  AcceptDecimal := True;
  AcceptNegative := True;
end;

procedure TPressMVPNumericInteractor.Notify(AEvent: TPressEvent);
var
  VKey: Char;
begin
  inherited;
  if AEvent is TPressMVPViewKeyPressEvent then
  begin
    VKey := TPressMVPViewKeyPressEvent(AEvent).Key;
    if VKey = DecimalSeparator then
    begin
      if not AcceptDecimal or (Pos(DecimalSeparator, Owner.View.AsString) > 0) then
        VKey := #0;
    end else if VKey = '-' then
    begin
      { TODO : Fix "-" interaction }
      if not AcceptNegative or (Pos('-', Owner.View.AsString) > 0) then
        VKey := #0;
    end else if not (VKey in [#8, '0'..'9']) then
      VKey := #0;
    TPressMVPViewKeyPressEvent(AEvent).Key := VKey;
  end;
end;

{ TPressMVPIntegerInteractor }

class function TPressMVPIntegerInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := inherited Apply(APresenter) and
   (APresenter.Model.Subject is TPressInteger);
end;

procedure TPressMVPIntegerInteractor.InitInteractor;
begin
  inherited;
  AcceptDecimal := False;
end;

{ TPressMVPFloatInteractor }

class function TPressMVPFloatInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := inherited Apply(APresenter) and
   ((APresenter.Model.Subject is TPressFloat) or
   (APresenter.Model.Subject is TPressCurrency));
end;

{ TPressMVPDateTimeInteractor }

class function TPressMVPDateTimeInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := inherited Apply(APresenter) and
   (APresenter.Model.Subject is TPressDateTime);
end;

procedure TPressMVPDateTimeInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  { TODO : Implement }
end;

{ TPressMVPDrawGridInteractor }

class function TPressMVPDrawGridInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter.View is TPressMVPGridView;
end;

procedure TPressMVPDrawGridInteractor.DrawCell(
  Sender: TPressMVPGridView; ACanvas: TCanvas;
  ACol, ARow: Integer; ARect: TRect; State: TGridDrawState);
var
  VAlignment: TAlignment;
  VText: string;
  VTop, VLeft: Integer;
begin
  if ACol = -1 then
  begin
    if (ARow = -1) or (Owner.Model.Count = 0) then
      VText := ''
    else
      VText := InttoStr(ARow + 1);
    VAlignment := taRightJustify;
  end else if ARow = -1 then
  begin
    VText := Owner.DisplayHeader(ACol);
    VAlignment := Owner.HeaderAlignment(ACol);
  end else
  begin
    VText := Owner.Model.DisplayText(ACol, ARow);
    VAlignment := Owner.Model.TextAlignment(ACol);
  end;
  VTop := ARect.Top + 1;
  case VAlignment of
    taLeftJustify:
      VLeft := ARect.Left + 2;
    taRightJustify:
      VLeft := ARect.Right - ACanvas.TextWidth(VText) - 2;
    else {taCenter}
      VLeft := (ARect.Left + ARect.Right - ACanvas.TextWidth(VText)) div 2;
  end;
  ACanvas.TextRect(ARect, VLeft, VTop, VText);
end;

function TPressMVPDrawGridInteractor.GetOwner: TPressMVPItemsPresenter;
begin
  Result := inherited Owner as TPressMVPItemsPresenter;
end;

procedure TPressMVPDrawGridInteractor.InitInteractor;
begin
  inherited;
  {$IFDEF PressViewNotification}
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewDrawCellEvent]);
  {$ELSE}{$IFDEF PressViewDirectEvent}
  (Owner.View as TPressMVPGridView).OnDrawCell := DrawCell;
  {$ENDIF}{$ENDIF}
end;

procedure TPressMVPDrawGridInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  {$IFDEF PressViewNotification}
  if AEvent is TPressMVPViewDrawCellEvent then
    with TPressMVPViewDrawCellEvent(AEvent) do
      DrawCell(Owner, Canvas, Col, Row, Rect, State);
  {$ENDIF}
end;

{ TPressMVPSelectGridInteractor }

class function TPressMVPSelectGridInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  { TODO : Use with ItemsPresenter (ListBox and Grid) }
  Result := APresenter.View is TPressMVPGridView;
end;

function TPressMVPSelectGridInteractor.GetOwner: TPressMVPItemsPresenter;
begin
  Result := inherited Owner as TPressMVPItemsPresenter;
end;

procedure TPressMVPSelectGridInteractor.InitInteractor;
begin
  inherited;
  {$IFDEF PressViewNotification}
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewSelectCellEvent]);
  {$ELSE}{$IFDEF PressViewDirectEvent}
  (Owner.View as TPressMVPGridView).OnSelectCell := SelectCell;
  {$ENDIF}{$ENDIF}
  Notifier.AddNotificationItem(Owner.Model.Selection,
   [TPressMVPSelectionChangedEvent]);
end;

procedure TPressMVPSelectGridInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  if AEvent is TPressMVPSelectionChangedEvent then
  begin
    Notifier.DisableEvents;
    try
      with Owner.Model.Selection.CreateIterator do
      try
        BeforeFirstItem;
        while NextItem do
          { TODO : SelectItem method clear the selection }
          Owner.View.SelectItem(Owner.Model.IndexOf(CurrentItem));
      finally
        Free;
      end;
    finally
      Notifier.EnableEvents;
    end;
  {$IFDEF PressViewNotification}
  end else if AEvent is TPressMVPViewSelectCellEvent then
    with TPressMVPViewSelectCellEvent(AEvent) do
      SelectCell(Owner, Col, Row, CanSelectPtr^);
  {$ELSE}
  end;
  {$ENDIF}
end;

procedure TPressMVPSelectGridInteractor.SelectCell(
  Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
begin
  if Owner.Model.Count = 0 then
    Exit;
  Notifier.DisableEvents;
  try
    Owner.Model.SelectIndex(ARow);
  finally
    Notifier.EnableEvents;
  end;
end;

{ TPressMVPCreateFormInteractor }

class function TPressMVPCreateFormInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter.Model is TPressMVPStructureModel;
end;

function TPressMVPCreateFormInteractor.GetModel: TPressMVPStructureModel;
begin
  Result := Owner.Model as TPressMVPStructureModel;
end;

procedure TPressMVPCreateFormInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.Model, [TPressMVPModelCreateFormEvent]);
end;

procedure TPressMVPCreateFormInteractor.Notify(AEvent: TPressEvent);
var
  VPresenterIndex: Integer;
  VPresenter: TPressMVPFormPresenter;
  VObject: TPressObject;
  VIncluding: Boolean;
begin
  inherited;
  if (AEvent is TPressMVPModelCreateFormEvent) and
   (Model.Selection.Count = 1) then
  begin
    VIncluding := TPressMVPModelCreateFormEvent(AEvent).Including; 
    VObject := Model.Selection[0];
    VPresenterIndex :=
     PressMVPRegisteredForms.IndexOfObjectClass(VObject.ClassType);
    if VPresenterIndex >= 0 then
    begin
      VPresenter := PressMVPRegisteredForms[VPresenterIndex].
       PresenterClass.Run(Owner.Parent, VObject, VIncluding);
      VPresenter.Model.HookedSubject := Owner.Model.Subject as TPressStructure;
    end;
  end;
end;

{ TPressMVPCloseFormInteractor }

class function TPressMVPCloseFormInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter is TPressMVPFormPresenter;
end;

function TPressMVPCloseFormInteractor.GetOwner: TPressMVPFormPresenter;
begin
  Result := inherited Owner as TPressMVPFormPresenter;
end;

procedure TPressMVPCloseFormInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner.View, [TPressMVPViewCloseFormEvent]);
  Notifier.AddNotificationItem(Owner.Model, [TPressMVPModelCloseFormEvent]);
end;

procedure TPressMVPCloseFormInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  if Owner.AutoDestroy or not (AEvent is TPressMVPViewCloseFormEvent) then
    with TPressMVPFreePresenterEvent.Create(Owner) do
      if Owner is TPressMVPMainFormPresenter then
        Notify
      else
        QueueNotification;
end;

{ TPressMVPFreePresenterInteractor }

class function TPressMVPFreePresenterInteractor.Apply(
  APresenter: TPressMVPPresenter): Boolean;
begin
  Result := APresenter is TPressMVPFormPresenter;
end;

procedure TPressMVPFreePresenterInteractor.InitInteractor;
begin
  inherited;
  Notifier.AddNotificationItem(Owner, [TPressMVPFreePresenterEvent]);
end;

procedure TPressMVPFreePresenterInteractor.Notify(AEvent: TPressEvent);
begin
  inherited;
  Owner.Free;
end;

{ TPressMVPValuePresenter }

class function TPressMVPValuePresenter.Apply(AModel: TPressMVPModel;
  AView: TPressMVPView): Boolean;
begin
  Result := (AModel is TPressMVPValueModel) and
   (AView is TPressMVPAttributeView);
end;

function TPressMVPValuePresenter.GetModel: TPressMVPValueModel;
begin
  Result := inherited Model as TPressMVPValueModel;
end;

function TPressMVPValuePresenter.GetView: TPressMVPAttributeView;
begin
  Result := inherited View as TPressMVPAttributeView;
end;

procedure TPressMVPValuePresenter.InternalUpdateModel;
begin
  View.UpdateModel(Model.Subject);
end;

procedure TPressMVPValuePresenter.InternalUpdateView;
begin
  View.UpdateView(Model.Subject);
end;

{ TPressMVPItemPresenter }

class function TPressMVPItemPresenter.Apply(AModel: TPressMVPModel;
  AView: TPressMVPView): Boolean;
begin
  Result := (AModel is TPressMVPReferenceModel) and (AView is TPressMVPItemView);
end;

destructor TPressMVPItemPresenter.Destroy;
begin
  FDisplayNameList.Free;
  inherited;
end;

function TPressMVPItemPresenter.DisplayValueAttribute: TPressValue;
var
  VSubject: TPressObject;
  VAttributeName: string;
  VAttribute: TPressAttribute;
begin
  if DisplayNameList.Count = 0 then
    raise EPressMVPError.CreateFmt(SDisplayNameMissing,
     [View.Control.ClassName, View.Control.Name]);

  VSubject := Model.Subject.Value;
  VAttributeName := DisplayNameList[0];
  if Assigned(VSubject) then
    VAttribute := VSubject.FindPathAttribute(VAttributeName)
  else
    { TODO : Check AttributeName into metadata }
    VAttribute := nil;

  if Assigned(VSubject) and not Assigned(VAttribute) then
    raise EPressMVPError.CreateFmt(SAttributeNotFound,
     [VSubject.ClassName, VAttributeName]);

  if Assigned(VAttribute) and not (VAttribute is TPressValue) then
    raise EPressMVPError.CreateFmt(SInvalidAttributeType,
     [VAttributeName, VAttribute.ClassName]);

  Result := TPressValue(VAttribute);
end;

function TPressMVPItemPresenter.GetDisplayNameList: TStrings;
begin
  if not Assigned(FDisplayNameList) then
    FDisplayNameList := TStringList.Create;
  Result := FDisplayNameList;
end;

function TPressMVPItemPresenter.GetModel: TPressMVPReferenceModel;
begin
  Result := inherited Model as TPressMVPReferenceModel;
end;

function TPressMVPItemPresenter.GetView: TPressMVPItemView;
begin
  Result := inherited View as TPressMVPItemView;
end;

procedure TPressMVPItemPresenter.InternalUpdateModel;
begin
  View.UpdateModel(Model.Subject);
end;

procedure TPressMVPItemPresenter.InternalUpdateView;
begin
  View.UpdateView(DisplayValueAttribute);
end;

procedure TPressMVPItemPresenter.SetDisplayNames(const Value: string);
begin
  if FDisplayNames <> Value then
  begin
    FDisplayNames := Value;
    DisplayNameList.Text := StringReplace(
     Value, SPressFieldDelimiter, SPressLineBreak, [rfReplaceAll]);
    { TODO : Check if the attributes exist }
  end;
end;

procedure TPressMVPItemPresenter.UpdateReferences(const ASearchString: string);
var
  VCaption: string;
  VObject: TPressObject;
  VDisplayName: string;
begin
  if DisplayNameList.Count > 0 then
    VDisplayName := DisplayNameList[0]
  else
    raise EPressError.CreateFmt(SDisplayNameMissing,
     [View.Control.ClassName, View.Control.Name]);
  { TODO : VDisplayName need to be the persistent name
    Look for the persistent name into the metadata }
  Model.UpdateQuery(VDisplayName, ASearchString);
  View.ClearReferences;
  with Model.CreateQueryIterator do
  try
    while not IsDone do
    begin
      VObject := CurrentItem.Instance;
      VCaption := VObject.AttributeByName(VDisplayName).DisplayText;
      View.AddReference(VCaption, VObject);
      Next;
    end;
  finally
    Free;
  end;
end;

{ TPressMVPItemsPresenter }

class function TPressMVPItemsPresenter.Apply(AModel: TPressMVPModel;
  AView: TPressMVPView): Boolean;
begin
  Result := (AModel is TPressMVPItemsModel) and (AView is TPressMVPItemsView);
end;

destructor TPressMVPItemsPresenter.Destroy;
begin
  FDisplayNameList.Free;
  inherited;
end;

function TPressMVPItemsPresenter.DisplayHeader(ACol: Integer): string;
begin
  { TODO : read from metadata or via CreateSubPresenter parameter }
  if FDisplayNames <> '' then
    Result := Format('- %d -', [ACol + 1])
  else
    Result := '';
end;

function TPressMVPItemsPresenter.GetDisplayNameList: TStrings;
begin
  if not Assigned(FDisplayNameList) then
    FDisplayNameList := TStringList.Create;
  Result := FDisplayNameList;
end;

function TPressMVPItemsPresenter.GetModel: TPressMVPItemsModel;
begin
  Result := inherited Model as TPressMVPItemsModel;
end;

function TPressMVPItemsPresenter.GetView: TPressMVPItemsView;
begin
  Result := inherited View as TPressMVPItemsView;
end;

function TPressMVPItemsPresenter.HeaderAlignment(ACol: Integer): TAlignment;
begin
  { TODO : Improve }
  Result := taCenter;
end;

procedure TPressMVPItemsPresenter.InternalUpdateModel;
begin
end;

procedure TPressMVPItemsPresenter.InternalUpdateView;
begin
  View.SetRowCount(Model.Count);
  View.UpdateView(Model.Subject);
end;

procedure TPressMVPItemsPresenter.ParseDisplayNameList;
var
  VPos1, VPos2: Integer;
  VName: string;
  VWidth: Integer;
  I: Integer;
begin
  View.SetColumnCount(DisplayNameList.Count);
  for I := 0 to Pred(DisplayNameList.Count) do
  begin
    VName := DisplayNameList[I];
    VWidth := 64;
    VPos1 := Pos(SPressBrackets[1], VName);
    if VPos1 > 0 then
    begin
      VPos2 := Pos(SPressBrackets[2], VName);
      if VPos2 > VPos1 then
      begin
        try
          VWidth := StrtoInt(Copy(VName, VPos1 + 1, VPos2 - VPos1 - 1));
        except
          on E: EConvertError do
            VWidth := 64;
          else
            raise;
        end;
        if VWidth < 16 then
          VWidth := 16;
        DisplayNameList[I] := Copy(VName, 1, VPos1 - 1);
      end;
    end;
    View.SetColumnWidth(I, VWidth);
  end;
  View.AlignColumns;
end;

procedure TPressMVPItemsPresenter.SetDisplayNames(const Value: string);
begin
  if FDisplayNames <> Value then
  begin
    FDisplayNames := Value;
    DisplayNameList.Text := StringReplace(
     Value, SPressFieldDelimiter, SPressLineBreak, [rfReplaceAll]);
    ParseDisplayNameList;
    { TODO : Check if the attributes exist }
    Model.DisplayNames := DisplayNameList.Text;
  end;
end;

{ TPressMVPFormPresenter }

class function TPressMVPFormPresenter.Apply(AModel: TPressMVPModel;
  AView: TPressMVPView): Boolean;
begin
  Result := (AModel is TPressMVPObjectModel) and (AView is TPressMVPFormView);
end;

function TPressMVPFormPresenter.AttributeByName(
  const AAttributeName: ShortString): TPressAttribute;
begin
  if Model.Subject is TPressObject then
    Result := TPressObject(Model.Subject).FindPathAttribute(AAttributeName)
  else
    Result := nil;
  if not Assigned(Result) then
    raise EPressError.CreateFmt(SAttributeNotFound,
     [Model.Subject.ClassName, AAttributeName]);
end;

procedure TPressMVPFormPresenter.BindCommand(
  ACommandClass: TPressMVPCommandClass; const AComponentName: ShortString);
var
  VCommand: TPressMVPCommand;
begin
  if not Assigned(ACommandClass) then
    ACommandClass := TPressMVPNullCommand;
  VCommand := Model.FindCommand(ACommandClass);
  if not Assigned(VCommand) then
  begin
    VCommand := ACommandClass.Create(Model);
    OwnedCommandList.Add(VCommand);
  end;
  VCommand.AddComponent(ComponentByName(AComponentName));
end;

function TPressMVPFormPresenter.ComponentByName(
  const AComponentName: ShortString): TComponent;
var
  VComponent: PComponent;
begin
  VComponent := View.Control.FieldAddress(AComponentName);
  if not Assigned(VComponent) or not Assigned(VComponent^) then
    raise EPressMVPError.CreateFmt(SComponentNotFound,
     [View.Control.ClassName, AComponentName]);
  Result := VComponent^;
end;

function TPressMVPFormPresenter.ControlByName(
  const AControlName: ShortString): TControl;
var
  VComponent: TComponent;
begin
  VComponent := ComponentByName(AControlName);
  if not (VComponent is TControl) then
    raise EPressMVPError.CreateFmt(SComponentIsNotAControl,
     [View.Control.ClassName, AControlName]);
  Result := TControl(VComponent);
end;

procedure TPressMVPFormPresenter.CreateQueryPresenter(
  const AControlName: ShortString);
begin
  FQueryPresenter :=
   CreateSubPresenter(SPressQueryItemsString, AControlName) as TPressMVPItemsPresenter;
end;

function TPressMVPFormPresenter.CreateSubPresenter(
  const AAttributeName, AControlName: ShortString;
  const ADisplayNames: string): TPressMVPPresenter;
var
  VAttribute: TPressAttribute;
  VControl: TControl;
  VModel: TPressMVPModel;
  VView: TPressMVPView;
begin
  VAttribute := AttributeByName(AAttributeName);
  VControl := ControlByName(AControlName);
  VModel := TPressMVPModel.CreateFromSubject(VAttribute);
  VView := TPressMVPView.CreateFromControl(VControl);
  try
    Result := TPressMVPPresenter.CreateFromControllers(VModel, VView);
  except
    VModel.Free;
    VView.Free;
    raise;
  end;
  AddSubPresenter(Result);
  if Result is TPressMVPItemPresenter then
    TPressMVPItemPresenter(Result).DisplayNames := ADisplayNames
  else if Result is TPressMVPItemsPresenter then
    TPressMVPItemsPresenter(Result).DisplayNames := ADisplayNames
  else if ADisplayNames <> '' then
    raise EPressMVPError.CreateFmt(SDisplayNameNotSupported,
     [VAttribute.ClassName, VAttribute.Owner.ClassName, VAttribute.Name]);
end;

destructor TPressMVPFormPresenter.Destroy;
begin
  FOwnedCommandList.Free;
  inherited;
end;

procedure TPressMVPFormPresenter.EditQueryPresenter(
  const ADisplayNames: string);
begin
  if not Assigned(FQueryPresenter) then
    raise EPressMVPError.CreateFmt(SUnassignedQuerySubPresenter, [ClassName]);
  FQueryPresenter.DisplayNames := ADisplayNames;
end;

function TPressMVPFormPresenter.GetModel: TPressMVPObjectModel;
begin
  Result := inherited Model as TPressMVPObjectModel;
end;

function TPressMVPFormPresenter.GetOwnedCommandList: TPressMVPCommandList;
begin
  if not Assigned(FOwnedCommandList) then
    FOwnedCommandList := TPressMVPCommandList.Create(True);
  Result := FOwnedCommandList;
end;

function TPressMVPFormPresenter.GetView: TPressMVPFormView;
begin
  Result := inherited View as TPressMVPFormView;
end;

procedure TPressMVPFormPresenter.InitPresenter;
begin
  inherited;
  FAutoDestroy := True;
end;

procedure TPressMVPFormPresenter.InternalUpdateModel;
begin
end;

procedure TPressMVPFormPresenter.InternalUpdateView;
begin
end;

class procedure TPressMVPFormPresenter.RegisterFormPresenter(
  AObjectClass: TPressObjectClass; AFormClass: TFormClass);
begin
  PressMVPRegisteredForms.Add(
   TPressMVPRegisteredForm.Create(Self, AObjectClass, AFormClass));
end;

class function TPressMVPFormPresenter.Run(
  AObject: TPressObject; AIncluding: Boolean;
  AAutoDestroy: Boolean): TPressMVPFormPresenter;
begin
  Result := Run(PressMainPresenter, AObject, AIncluding, AAutoDestroy);
end;

class function TPressMVPFormPresenter.Run(
  AOwner: TPressMVPPresenter; AObject: TPressObject; AIncluding: Boolean;
  AAutoDestroy: Boolean): TPressMVPFormPresenter;
var
  VModel: TPressMVPObjectModel;
  VView: TPressMVPView;
  VFormClass: TFormClass;
  VObjectClass: TPressObjectClass;
  VIndex: Integer;
  VObjectIsMissing: Boolean;
begin
  VIndex := PressMVPRegisteredForms.IndexOfPresenterClass(Self);
  if VIndex >= 0 then
  begin
    VFormClass := PressMVPRegisteredForms[VIndex].FormClass;
    VObjectClass := PressMVPRegisteredForms[VIndex].ObjectClass;
  end else
    raise EPressError.CreateFmt(SClassNotFound, [ClassName]);
  VObjectIsMissing := not Assigned(AObject);
  if VObjectIsMissing then
  begin
    AObject := VObjectClass.Create;
    AIncluding := True;
  end;
  { TODO : Catch memory leakage when an exception is raised }
  VModel := TPressMVPModel.CreateFromSubject(AObject) as TPressMVPObjectModel;
  VModel.IsIncluding := AIncluding;
  if VObjectIsMissing then
    AObject.Release;
  VView := TPressMVPView.CreateFromControl(VFormClass.Create(nil), True);
  Result := Create(VModel, VView);
  if Assigned(AOwner) then
    AOwner.AddSubPresenter(Result)
  else
    PressMainPresenter.AddSubPresenter(Result);
  Result.FAutoDestroy := AAutoDestroy;
  Result.UpdateView;
  Result.View.Control.Show;
end;

{ TPressMVPMainFormPresenter }

constructor TPressMVPMainFormPresenter.Create;
begin
  if not Assigned(Application) or not Assigned(Application.MainForm) then
    raise EPressError.Create(SMainFormNotAssigned);
  inherited Create(InternalCreateModel, InternalCreateView);
end;

procedure TPressMVPMainFormPresenter.Idle(
  Sender: TObject; var Done: Boolean);
begin
  {$IFDEF PressLogIdle}PressLogMsg(Self, 'Idle', [Sender]);{$ENDIF}
  PressProcessEventQueue;
  if Assigned(FOnIdle) then
    FOnIdle(Sender, Done);
end;

procedure TPressMVPMainFormPresenter.InitPresenter;
begin
  inherited;
  FOnIdle := Application.OnIdle;
  Application.OnIdle := Idle;
end;

function TPressMVPMainFormPresenter.InternalCreateModel: TPressMVPModel;
begin
  Result := TPressMVPObjectModel.Create(nil);
end;

function TPressMVPMainFormPresenter.InternalCreateView: TPressMVPFormView;
begin
  Result := TPressMVPFormView.Create(Application.MainForm);
end;

procedure TPressMVPMainFormPresenter.ShutDown;
begin
  Application.Terminate;
end;

{ TPressMVPRegisteredForm }

constructor TPressMVPRegisteredForm.Create(
  APresenterClass: TPressMVPFormPresenterClass;
  AObjectClass: TPressObjectClass; AFormClass: TFormClass);
begin
  inherited Create;
  FPresenterClass := APresenterClass;
  FObjectClass := AObjectClass;
  FFormClass := AFormClass;
end;

{ TPressMVPRegisteredFormList }

function TPressMVPRegisteredFormList.Add(
  AObject: TPressMVPRegisteredForm): Integer;
begin
  Result := inherited Add(AObject);
end;

function TPressMVPRegisteredFormList.CreateIterator: TPressMVPRegisteredFormIterator;
begin
  Result := TPressMVPRegisteredFormIterator.Create(Self);
end;

function TPressMVPRegisteredFormList.GetItems(
  AIndex: Integer): TPressMVPRegisteredForm;
begin
  Result := inherited Items[AIndex] as TPressMVPRegisteredForm;
end;

function TPressMVPRegisteredFormList.IndexOf(
  AObject: TPressMVPRegisteredForm): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

function TPressMVPRegisteredFormList.IndexOfObjectClass(
  AObjectClass: TPressObjectClass): Integer;
begin
  for Result := 0 to Pred(Count) do
    if Items[Result].ObjectClass = AObjectClass then
      Exit;
  Result := -1;
end;

function TPressMVPRegisteredFormList.IndexOfPresenterClass(
  APresenterClass: TPressMVPFormPresenterClass): Integer;
begin
  for Result := 0 to Pred(Count) do
    if Items[Result].PresenterClass = APresenterClass then
      Exit;
  Result := -1;
end;

procedure TPressMVPRegisteredFormList.Insert(Index: Integer;
  AObject: TPressMVPRegisteredForm);
begin
  inherited Insert(Index, AObject);
end;

function TPressMVPRegisteredFormList.InternalCreateIterator: TPressCustomIterator;
begin
  Result := CreateIterator;
end;

function TPressMVPRegisteredFormList.Remove(
  AObject: TPressMVPRegisteredForm): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TPressMVPRegisteredFormList.SetItems(AIndex: Integer;
  const Value: TPressMVPRegisteredForm);
begin
  inherited Items[AIndex] := Value;
end;

{ TPressMVPRegisteredFormIterator }

function TPressMVPRegisteredFormIterator.GetCurrentItem: TPressMVPRegisteredForm;
begin
  Result := inherited CurrentItem as TPressMVPRegisteredForm;
end;

procedure RegisterInteractors;
begin
  TPressMVPNextControlInteractor.RegisterInteractor;
  TPressMVPUpdateComboInteractor.RegisterInteractor;
  TPressMVPOpenComboInteractor.RegisterInteractor;
  TPressMVPChangeModelInteractor.RegisterInteractor;
  TPressMVPExitUpdatableInteractor.RegisterInteractor;
  TPressMVPClickUpdatableInteractor.RegisterInteractor;
  TPressMVPDblClickSelectableInteractor.RegisterInteractor;
  TPressMVPEditableInteractor.RegisterInteractor;
  TPressMVPIntegerInteractor.RegisterInteractor;
  TPressMVPFloatInteractor.RegisterInteractor;
  TPressMVPDateTimeInteractor.RegisterInteractor;
  TPressMVPDrawGridInteractor.RegisterInteractor;
  TPressMVPSelectGridInteractor.RegisterInteractor;
  TPressMVPCreateFormInteractor.RegisterInteractor;
  TPressMVPCloseFormInteractor.RegisterInteractor;
  TPressMVPFreePresenterInteractor.RegisterInteractor;
end;

procedure RegisterPresenters;
begin
  TPressMVPValuePresenter.RegisterPresenter;
  TPressMVPItemsPresenter.RegisterPresenter;
  TPressMVPItemPresenter.RegisterPresenter;
  TPressMVPFormPresenter.RegisterPresenter;
end;

initialization
  RegisterInteractors;
  RegisterPresenters;

end.
