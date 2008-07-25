(*
  PressObjects, Cross Component Library (VCL and LCL) Broker
  Copyright (C) 2008 Laserpress Ltda.

  http://www.pressobjects.org

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit PressXCLBroker;

{$I Press.inc}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes,
  Controls,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  Grids,
{$IFDEF FPC}
  Calendar,
{$ENDIF}
  Forms,
  PressClasses,
  PressNotifier,
  PressUser,
  PressMVP,
  PressMVPModel,
  PressMVPView,
  PressMVPPresenter,
  PressMVPFactory,
  PressMVPWidget;

type
  TPressMVPWidgetManager = class(TPressManagedIObject, IPressMVPWidgetManager)
  protected
    function ControlName(AControl: TObject): string;
    function CreateForm(AFormClass: TClass): TObject;
    procedure Draw(ACanvasHandle: TObject; AShape: TPressShapeType; X1, Y1, X2, Y2: Integer; ASolid: Boolean);
    procedure ShowForm(AForm: TObject; AModal: Boolean);
    function TextHeight(ACanvasHandle: TObject; const AStr: string): Integer;
    procedure TextRect(ACanvasHandle: TObject; ARect: TPressRect; ALeft, ATop: Integer; const AStr: string);
    function TextWidth(ACanvasHandle: TObject; const AStr: string): Integer;
  end;

{$IFDEF BORLAND_CG}
  TCustomDrawGrid = Grids.TDrawGrid;
  TCustomCalendar = ComCtrls.TCommonCalendar;
  TOnDrawCell = TDrawCellEvent;
{$ENDIF}

  TPressMVPView = class(TPressMVPBaseView, IPressMVPView)
  private
    FAccessMode: TPressAccessMode;
    FIsChanged: Boolean;
    FModel: TPressMVPModel;
    FViewClickEvent: TNotifyEvent;
    FViewDblClickEvent: TNotifyEvent;
    FViewMouseDownEvent: TMouseEvent;
    FViewMouseUpEvent: TMouseEvent;
    function AccessError(const ADataType: string): EPressMVPError;
    function GetAccessMode: TPressAccessMode;
    function GetIsChanged: Boolean;
    function GetModel: TPressMVPModel;
    function GetReadOnly: Boolean;
    procedure SetAccessMode(Value: TPressAccessMode);
    procedure SetReadOnly(Value: Boolean);
  protected
    procedure ViewClickEvent(Sender: TObject); virtual;
    procedure ViewDblClickEvent(Sender: TObject); virtual;
    procedure ViewMouseDownEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure ViewMouseUpEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
  protected
    procedure Changed;
    function GetText: string; virtual;
    procedure InitView; override;
    procedure InternalAccessModeUpdated; virtual;
    procedure InternalReset; virtual;
    procedure InternalUpdate; virtual;
    procedure ModelChanged(AChangeType: TPressMVPChangeType); virtual;
    procedure ReleaseControl; override;
    procedure SetModel(Value: TPressMVPModel);
    procedure SetText(const Value: string); virtual;
    procedure Unchanged;
    property Model: TPressMVPModel read GetModel;
  public
    procedure Update;
    property AccessMode: TPressAccessMode read FAccessMode write SetAccessMode;
    property IsChanged: Boolean read FIsChanged;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property Text: string read GetText write SetText;
  end;

  TPressMVPAttributeView = class(TPressMVPView, IPressMVPAttributeView)
  private
    function GetModel: TPressMVPAttributeModel;
  protected
    function GetAsBoolean: Boolean; virtual;
    function GetAsDateTime: TDateTime; virtual;
    function GetAsInteger: Integer; virtual;
    function GetAsString: string; virtual;
    function GetText: string; override;
    function GetIsClear: Boolean; virtual;
    procedure InternalClear; virtual;
    procedure SetSize(Value: Integer); virtual;
  public
    procedure Clear;
    property AsBoolean: Boolean read GetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime;
    property AsInteger: Integer read GetAsInteger;
    property AsString: string read GetAsString;
    property IsClear: Boolean read GetIsClear;
    property Model: TPressMVPAttributeModel read GetModel;
    property Size: Integer write SetSize;
  end;

  TPressMVPWinView = class(TPressMVPAttributeView, IPressMVPWinView)
  private
    FViewEnterEvent: TNotifyEvent;
    FViewExitEvent: TNotifyEvent;
    FViewKeyDownEvent: TKeyEvent;
    FViewKeyPressEvent: TKeyPressEvent;
    FViewKeyUpEvent: TKeyEvent;
    function GetControl: TWinControl;
  private
    procedure UpdateRelatedLabel;
  protected
    procedure ViewEnterEvent(Sender: TObject); virtual;
    procedure ViewExitEvent(Sender: TObject); virtual;
    procedure ViewKeyDownEvent(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure ViewKeyPressEvent(Sender: TObject; var Key: Char); virtual;
    procedure ViewKeyUpEvent(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
  protected
    procedure InitView; override;
    procedure InternalAccessModeUpdated; override;
    procedure ReleaseControl; override;
  public
    function Focused: Boolean;
    procedure SelectNext; virtual;
    procedure SetFocus;
    property Control: TWinControl read GetControl;
  end;

  TPressMVPEditView = class(TPressMVPWinView, IPressMVPEditView)
  private
    FViewChangeEvent: TNotifyEvent;
    function GetControl: TCustomEdit;
    function GetSelectedText: string;
  protected
    procedure ViewChangeEvent(Sender: TObject); virtual;
    procedure ViewEnterEvent(Sender: TObject); override;
  protected
    function GetAsString: string; override;
    function GetIsClear: Boolean; override;
    procedure InitView; override;
    procedure InternalClear; override;
    procedure InternalUpdate; override;
    procedure ReleaseControl; override;
    procedure SetSize(Value: Integer); override;
    procedure SetText(const Value: string); override;
  public
    class function Apply(AControl: TObject): Boolean; override;
    property Control: TCustomEdit read GetControl;
    property SelectedText: string read GetSelectedText;
  end;

  TPressMVPDateTimeView = class(TPressMVPWinView, IPressMVPDateTimeView)
  private
    function GetControl: TCustomCalendar;
  protected
    procedure ViewClickEvent(Sender: TObject); override;
  protected
    function GetAsDateTime: TDateTime; override;
    function GetAsString: string; override;
    function GetIsClear: Boolean; override;
    procedure InternalClear; override;
    procedure InternalUpdate; override;
  public
    class function Apply(AControl: TObject): Boolean; override;
    property Control: TCustomCalendar read GetControl;
  end;

  TPressMVPBooleanView = class(TPressMVPWinView, IPressMVPBooleanView)
  protected
    procedure ViewClickEvent(Sender: TObject); override;
  end;

  TPressMVPCheckBoxView = class(TPressMVPBooleanView, IPressMVPCheckBoxView)
  private
    function GetControl: TCustomCheckBox;
  protected
    function GetAsBoolean: Boolean; override;
    function GetIsClear: Boolean; override;
    procedure InternalClear; override;
    procedure InternalUpdate; override;
  public
    class function Apply(AControl: TObject): Boolean; override;
    property Control: TCustomCheckBox read GetControl;
  end;

  TPressMVPItemView = class(TPressMVPWinView, IPressMVPItemView)
  protected
    procedure ViewEnterEvent(Sender: TObject); override;
    procedure ViewExitEvent(Sender: TObject); override;
  protected
    function GetReferencesVisible: Boolean; virtual;
    function GetSelectedText: string; virtual;
    procedure InternalAddReference(const ACaption: string); virtual; abstract;
    procedure InternalClearReferences; virtual; abstract;
  public
    procedure AddReference(const ACaption: string);
    procedure AssignReferences(AItems: TStrings);
    procedure ClearReferences;
    property ReferencesVisible: Boolean read GetReferencesVisible;
    property SelectedText: string read GetSelectedText;
  end;

  TPressMVPComboBoxView = class(TPressMVPItemView, IPressMVPComboBoxView)
  private
    FViewChangeEvent: TNotifyEvent;
    FViewDrawItemEvent: TDrawItemEvent;
    FViewDropDownEvent: TNotifyEvent;
    {$IFDEF FPC}
    FViewSelectEvent: TNotifyEvent;
    {$ENDIF}
    function GetControl: TCustomComboBox;
  protected
    procedure ViewChangeEvent(Sender: TObject); virtual;
    {$IFDEF BORLAND_CG}
    procedure ViewClickEvent(Sender: TObject); override;
    {$ENDIF}
    procedure ViewDrawItemEvent(AControl: TWinControl; AIndex: Integer; ARect: TRect; AState: TOwnerDrawState); virtual;
    procedure ViewDropDownEvent(Sender: TObject); virtual;
    {$IFDEF FPC}
    procedure ViewSelectEvent(Sender: TObject); virtual;
    {$ENDIF}
  protected
    function GetAsInteger: Integer; override;
    function GetAsString: string; override;
    function GetIsClear: Boolean; override;
    function GetReferencesVisible: Boolean; override;
    function GetSelectedText: string; override;
    procedure InitView; override;
    procedure InternalAddReference(const ACaption: string); override;
    procedure InternalClear; override;
    procedure InternalClearReferences; override;
    procedure InternalUpdate; override;
    procedure ReleaseControl; override;
    procedure SetSize(Value: Integer); override;
  public
    class function Apply(AControl: TObject): Boolean; override;
    procedure HideReferences;
    procedure SelectAll;
    procedure ShowReferences;
    property Control: TCustomComboBox read GetControl;
  end;

  TPressMVPItemsView = class(TPressMVPWinView, IPressMVPItemsView)
  private
    function GetModel: TPressMVPItemsModel;
    function GetRowCount: Integer;
    procedure SetRowCount(ARowCount: Integer);
  protected
    function InternalCurrentItem: Integer; virtual; abstract;
    function InternalGetRowCount: Integer; virtual; abstract;
    procedure InternalSelectItem(AIndex: Integer); virtual; abstract;
    procedure InternalSetColumnCount(AColumnCount: Integer); virtual;
    procedure InternalSetColumnWidth(AColumn, AWidth: Integer); virtual;
    procedure InternalSetRowCount(ARowCount: Integer); virtual; abstract;
    procedure InternalUpdate; override;
    property RowCount: Integer read GetRowCount write SetRowCount;
  public
    function CurrentItem: Integer;
    procedure SelectItem(AIndex: Integer);
    property Model: TPressMVPItemsModel read GetModel;
  end;

  TPressMVPListBoxView = class(TPressMVPItemsView, IPressMVPListBoxView)
  private
    FViewDrawItemEvent: TDrawItemEvent;
    procedure ViewDrawItemEvent(AControl: TWinControl; AIndex: Integer; ARect: TRect; AState: TOwnerDrawState); virtual;
    function GetControl: TCustomListBox;
  protected
    procedure InitView; override;
    function InternalCurrentItem: Integer; override;
    function InternalGetRowCount: Integer; override;
    procedure InternalSelectItem(AIndex: Integer); override;
    procedure InternalSetRowCount(ARowCount: Integer); override;
    procedure ReleaseControl; override;
  public
    class function Apply(AControl: TObject): Boolean; override;
    property Control: TCustomListBox read GetControl;
  end;

  TPressMVPGridView = class(TPressMVPItemsView, IPressMVPGridView)
  private
    FViewDrawCellEvent: TOnDrawCell;
    function GetControl: TCustomDrawGrid;
  protected
    procedure ViewDrawCellEvent(Sender: TObject; ACol, ARow: Longint; ARect: TRect; State: TGridDrawState); virtual;
    procedure ViewMouseUpEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  protected
    procedure InitView; override;
    procedure InternalAlignColumns; virtual;
    function InternalCurrentItem: Integer; override;
    function InternalGetRowCount: Integer; override;
    procedure InternalReset; override;
    procedure InternalSelectItem(AIndex: Integer); override;
    procedure InternalSetColumnCount(AColumnCount: Integer); override;
    procedure InternalSetColumnWidth(AColumn, AWidth: Integer); override;
    procedure InternalSetRowCount(ARowCount: Integer); override;
    procedure ReleaseControl; override;
  public
    procedure AlignColumns;
    class function Apply(AControl: TObject): Boolean; override;
    property Control: TCustomDrawGrid read GetControl;
  end;

  TPressMVPCaptionView = class(TPressMVPAttributeView)
  protected
    function GetAsString: string; override;
    procedure InternalUpdate; override;
    procedure SetText(const Value: string); override;
  end;

  TPressMVPLabelView = class(TPressMVPCaptionView)
  public
    class function Apply(AControl: TObject): Boolean; override;
  end;

  TPressMVPPanelView = class(TPressMVPCaptionView)
  public
    class function Apply(AControl: TObject): Boolean; override;
  end;

  TPressMVPPictureView = class(TPressMVPAttributeView)
  private
    function GetControl: TImage;
  protected
    procedure InternalUpdate; override;
  public
    class function Apply(AControl: TObject): Boolean; override;
    property Control: TImage read GetControl;
  end;

  TPressMVPCustomFormView = class(TPressMVPView, IPressMVPCustomFormView)
  private
    function GetControl: TCustomForm;
  public
    function ComponentByName(const AComponentName: ShortString): TObject;
    property Control: TCustomForm read GetControl;
  end;

  TPressMVPFormViewClass = class of TPressMVPFormView;

  TPressMVPFormView = class(TPressMVPCustomFormView, IPressMVPFormView)
  private
    FViewCloseEvent: TCloseEvent;
  protected
    procedure ViewCloseEvent(Sender: TObject; var Action: TCloseAction); virtual;
  protected
    function GetText: string; override;
    procedure InitView; override;
    procedure ReleaseControl; override;
    procedure SetText(const Value: string); override;
  public
    class function Apply(AControl: TObject): Boolean; override;
    procedure Close;
  end;

procedure PressXCLForm(APresenter: TPressMVPFormPresenterClass; AForm: TFormClass);

implementation

uses
  Math,
  Graphics,
  PressSubject,
  PressConsts,
  PressUtils,
  PressPicture;

type
  { Friend classes }

  TPressXCLControlFriend = class(TControl);
  TPressXCLWinControlFriend = class(TWinControl);
  TPressXCLCustomEditFriend = class(TCustomEdit);
  TPressXCLCustomCalendarFriend = class(TCustomCalendar);
  TPressXCLCustomCheckBoxFriend = class(TCustomCheckBox);
  TPressXCLCustomComboBoxFriend = class(TCustomComboBox);
  TPressXCLCustomListBoxFriend = class(TCustomListBox);
  TPressXCLCustomLabelFriend = class(TCustomLabel);
  TPressXCLCustomFormFriend = class(TCustomForm);

procedure PressXCLForm(
  APresenter: TPressMVPFormPresenterClass; AForm: TFormClass);
begin
  PressDefaultMVPFactory.Forms.FormOfPresenter(APresenter).AssignForm(AForm);
end;

{ TPressMVPWidgetManager }

function TPressMVPWidgetManager.ControlName(AControl: TObject): string;
begin
  Result := (AControl as TControl).Name;
end;

function TPressMVPWidgetManager.CreateForm(AFormClass: TClass): TObject;
begin
  Result := TCustomFormClass(AFormClass).Create(nil);
end;

procedure TPressMVPWidgetManager.Draw(ACanvasHandle: TObject;
  AShape: TPressShapeType; X1, Y1, X2, Y2: Integer; ASolid: Boolean);
begin
  { TODO : Save and restore Brush and Pen status }
  TCanvas(ACanvasHandle).Pen.Color := TCanvas(ACanvasHandle).Font.Color;
  if ASolid then
    TCanvas(ACanvasHandle).Brush.Color := TCanvas(ACanvasHandle).Font.Color;
  case AShape of
    shRectangle: TCanvas(ACanvasHandle).Rectangle(X1, Y1, X2, Y2);
    shEllipse: TCanvas(ACanvasHandle).Ellipse(X1, Y1, X2, Y2);
  end;
end;

procedure TPressMVPWidgetManager.ShowForm(AForm: TObject; AModal: Boolean);
begin
  if AModal then
    TCustomForm(AForm).ShowModal
  else
    TCustomForm(AForm).Show;
end;

function TPressMVPWidgetManager.TextHeight(
  ACanvasHandle: TObject; const AStr: string): Integer;
begin
  Result := TCanvas(ACanvasHandle).TextHeight(AStr);
end;

procedure TPressMVPWidgetManager.TextRect(ACanvasHandle: TObject;
  ARect: TPressRect; ALeft, ATop: Integer; const AStr: string);
begin
  TCanvas(ACanvasHandle).TextRect(TRect(ARect), ALeft, ATop, AStr);
end;

function TPressMVPWidgetManager.TextWidth(
  ACanvasHandle: TObject; const AStr: string): Integer;
begin
  Result := TCanvas(ACanvasHandle).TextWidth(AStr);
end;

{ TPressMVPView }

function TPressMVPView.AccessError(
  const ADataType: string): EPressMVPError;
begin
  Result := EPressMVPError.CreateFmt(SViewAccessError,
   [ClassName, (Control as TControl).Name, ADataType]);
end;

procedure TPressMVPView.Changed;
begin
  FIsChanged := True;
end;

function TPressMVPView.GetAccessMode: TPressAccessMode;
begin
  Result := FAccessMode;
end;

function TPressMVPView.GetIsChanged: Boolean;
begin
  Result := FIsChanged;
end;

function TPressMVPView.GetModel: TPressMVPModel;
begin
  if not Assigned(FModel) then
    raise EPressMVPError.Create(SUnassignedModel);
  Result := FModel;
end;

function TPressMVPView.GetReadOnly: Boolean;
begin
  Result := AccessMode <> amWritable;
end;

function TPressMVPView.GetText: string;
begin
  raise AccessError('Text');
end;

procedure TPressMVPView.InitView;
begin
  inherited;
  FAccessMode := amWritable;
  with TPressXCLControlFriend(Control) do
  begin
    FViewClickEvent := OnClick;
    FViewDblClickEvent := OnDblClick;
    FViewMouseDownEvent := OnMouseDown;
    FViewMouseUpEvent := OnMouseUp;
    OnClick := {$IFDEF FPC}@{$ENDIF}ViewClickEvent;
    OnDblClick := {$IFDEF FPC}@{$ENDIF}ViewDblClickEvent;
    OnMouseDown := {$IFDEF FPC}@{$ENDIF}ViewMouseDownEvent;
    OnMouseUp := {$IFDEF FPC}@{$ENDIF}ViewMouseUpEvent;
  end;
end;

procedure TPressMVPView.InternalAccessModeUpdated;
begin
  Update;
end;

procedure TPressMVPView.InternalReset;
begin
  AccessMode := Model.AccessMode;
  Update;
end;

procedure TPressMVPView.InternalUpdate;
begin
end;

procedure TPressMVPView.ModelChanged(AChangeType: TPressMVPChangeType);
begin
  case AChangeType of
    ctSubject: InternalUpdate;
    ctDisplay: InternalReset;
  end;
end;

procedure TPressMVPView.ReleaseControl;
begin
  with TPressXCLControlFriend(Control) do
  begin
    OnClick := FViewClickEvent;
    OnDblClick := FViewDblClickEvent;
    OnMouseDown := FViewMouseDownEvent;
    OnMouseUp := FViewMouseUpEvent;
  end;
end;

procedure TPressMVPView.SetAccessMode(Value: TPressAccessMode);
begin
  if FAccessMode <> Value then
  begin
    FAccessMode := Value;
    InternalAccessModeUpdated;
  end;
end;

procedure TPressMVPView.SetModel(Value: TPressMVPModel);
begin
  inherited;
  if FModel <> Value then
  begin
    if Assigned(FModel) then
      FModel.OnChange := nil;
    FModel := Value;
    if Assigned(FModel) then
      FModel.OnChange := {$ifdef fpc}@{$endif}ModelChanged;
  end;
end;

procedure TPressMVPView.SetReadOnly(Value: Boolean);
begin
  if Value then
    AccessMode := amVisible
  else
    AccessMode := amWritable;
end;

procedure TPressMVPView.SetText(const Value: string);
begin
  raise AccessError('Text');
end;

procedure TPressMVPView.Unchanged;
begin
  FIsChanged := False;
end;

procedure TPressMVPView.Update;
begin
  if Model.HasSubject then
    InternalUpdate;
end;

procedure TPressMVPView.ViewClickEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewClickEvent.Create(Self).Notify;
  if Assigned(FViewClickEvent) then
    FViewClickEvent(Sender);
end;

procedure TPressMVPView.ViewDblClickEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewDblClickEvent.Create(Self).Notify;
  if Assigned(FViewDblClickEvent) then
    FViewDblClickEvent(Sender);
end;

procedure TPressMVPView.ViewMouseDownEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if EventsDisabled then
    Exit;
  //TPressMVPViewMouseDownEvent.Create(Self, Button, Shift, X, Y).Notify;
  if Assigned(FViewMouseDownEvent) then
    FViewMouseDownEvent(Sender, Button, Shift, X, Y);
end;

procedure TPressMVPView.ViewMouseUpEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if EventsDisabled then
    Exit;
  //TPressMVPViewMouseUpEvent.Create(Self, Button, Shift, X, Y).Notify;
  if Assigned(FViewMouseUpEvent) then
    FViewMouseUpEvent(Sender, Button, Shift, X, Y);
end;

{ TPressMVPAttributeView }

procedure TPressMVPAttributeView.Clear;
begin
  InternalClear;
end;

function TPressMVPAttributeView.GetAsBoolean: Boolean;
begin
  raise AccessError('Boolean');
end;

function TPressMVPAttributeView.GetAsDateTime: TDateTime;
begin
  raise AccessError('DateTime');
end;

function TPressMVPAttributeView.GetAsInteger: Integer;
begin
  raise AccessError('Integer');
end;

function TPressMVPAttributeView.GetAsString: string;
begin
  raise AccessError('String');
end;

function TPressMVPAttributeView.GetIsClear: Boolean;
begin
  Result := False;
end;

function TPressMVPAttributeView.GetModel: TPressMVPAttributeModel;
begin
  Result := inherited Model as TPressMVPAttributeModel;
end;

function TPressMVPAttributeView.GetText: string;
begin
  Result := AsString;
end;

procedure TPressMVPAttributeView.InternalClear;
begin
end;

procedure TPressMVPAttributeView.SetSize(Value: Integer);
begin
end;

{ TPressMVPWinView }

function TPressMVPWinView.Focused: Boolean;
begin
  Result := Control.Focused;
end;

function TPressMVPWinView.GetControl: TWinControl;
begin
  Result := inherited Control as TWinControl;
end;

procedure TPressMVPWinView.InitView;
begin
  inherited;
  with TPressXCLWinControlFriend(Control) do
  begin
    FViewEnterEvent := OnEnter;
    FViewExitEvent := OnExit;
    FViewKeyDownEvent := OnKeyDown;
    FViewKeyPressEvent := OnKeyPress;
    FViewKeyUpEvent := OnKeyUp;
    OnEnter := {$IFDEF FPC}@{$ENDIF}ViewEnterEvent;
    OnExit := {$IFDEF FPC}@{$ENDIF}ViewExitEvent;
    OnKeyDown := {$IFDEF FPC}@{$ENDIF}ViewKeyDownEvent;
    OnKeyPress := {$IFDEF FPC}@{$ENDIF}ViewKeyPressEvent;
    OnKeyUp := {$IFDEF FPC}@{$ENDIF}ViewKeyUpEvent;
  end;
end;

procedure TPressMVPWinView.InternalAccessModeUpdated;
begin
  inherited;
  UpdateRelatedLabel;
end;

procedure TPressMVPWinView.ReleaseControl;
begin
  with TPressXCLWinControlFriend(Control) do
  begin
    OnEnter := FViewEnterEvent;
    OnExit := FViewExitEvent;
    OnKeyDown := FViewKeyDownEvent;
    OnKeyPress := FViewKeyPressEvent;
    OnKeyUp := FViewKeyUpEvent;
  end;
  inherited;
end;

procedure TPressMVPWinView.SelectNext;
var
  VWinControl: TWinControl;
begin
  VWinControl := Control.Parent;
  if Assigned(VWinControl) then
  begin
    while Assigned(VWinControl.Parent) do
      VWinControl := VWinControl.Parent;
    TPressXCLWinControlFriend(VWinControl).SelectNext(
     Control as TWinControl, True, True);
  end;
end;

procedure TPressMVPWinView.SetFocus;
begin
  Control.SetFocus;
end;

procedure TPressMVPWinView.UpdateRelatedLabel;
var
  VOwner: TComponent;
  VLabel: TCustomLabel;
  I: Integer;
begin
  VOwner := Control.Owner;
  if Assigned(VOwner) then
    for I := 0 to Pred(VOwner.ComponentCount) do
      if (VOwner.Components[I] is TCustomLabel) then
      begin
        VLabel := TCustomLabel(VOwner.Components[I]);
        if TPressXCLCustomLabelFriend(VLabel).FocusControl = Control then
        begin
          VLabel.Enabled := AccessMode = amWritable;
          Exit;
        end;
      end;
end;

procedure TPressMVPWinView.ViewEnterEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  Unchanged;
  TPressMVPViewEnterEvent.Create(Self).Notify;
  if Assigned(FViewEnterEvent) then
    FViewEnterEvent(Sender);
end;

procedure TPressMVPWinView.ViewExitEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewExitEvent.Create(Self).Notify;
  if Assigned(FViewExitEvent) then
    FViewExitEvent(Sender);
end;

procedure TPressMVPWinView.ViewKeyDownEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewKeyDownEvent.Create(Self, Key, Shift).Notify;
  if (Key <> 0) and Assigned(FViewKeyDownEvent) then
    FViewKeyDownEvent(Sender, Key, Shift);
end;

procedure TPressMVPWinView.ViewKeyPressEvent(Sender: TObject; var Key: Char);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewKeyPressEvent.Create(Self, Key).Notify;
  if (Key <> #0) and Assigned(FViewKeyPressEvent) then
    FViewKeyPressEvent(Sender, Key);
end;

procedure TPressMVPWinView.ViewKeyUpEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewKeyUpEvent.Create(Self, Key, Shift).Notify;
  if (Key <> 0) and Assigned(FViewKeyUpEvent) then
    FViewKeyUpEvent(Sender, Key, Shift);
end;

{ TPressMVPEditView }

class function TPressMVPEditView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomEdit;
end;

function TPressMVPEditView.GetAsString: string;
begin
  Result := PressDecodeString(TPressXCLCustomEditFriend(Control).Text);
end;

function TPressMVPEditView.GetControl: TCustomEdit;
begin
  Result := inherited Control as TCustomEdit;
end;

function TPressMVPEditView.GetIsClear: Boolean;
begin
  Result := Control.Text = '';
end;

function TPressMVPEditView.GetSelectedText: string;
begin
  Result := Control.SelText;
end;

procedure TPressMVPEditView.InitView;
begin
  inherited;
  with TPressXCLCustomEditFriend(Control) do
  begin
    FViewChangeEvent := OnChange;
    OnChange := {$IFDEF FPC}@{$ENDIF}ViewChangeEvent;
  end;
end;

procedure TPressMVPEditView.InternalClear;
begin
  TPressXCLCustomEditFriend(Control).Text := '';
end;

procedure TPressMVPEditView.InternalUpdate;
begin
  inherited;
  if AccessMode = amInvisible then
    TPressXCLCustomEditFriend(Control).Text := ''
  else
    TPressXCLCustomEditFriend(Control).Text := PressEncodeString(Model.AsString);
  Control.Enabled := AccessMode = amWritable;
  Unchanged;
end;

procedure TPressMVPEditView.ReleaseControl;
begin
  with TPressXCLCustomEditFriend(Control) do
  begin
    OnChange := FViewChangeEvent;
  end;
  inherited;
end;

procedure TPressMVPEditView.SetSize(Value: Integer);
begin
  TPressXCLCustomEditFriend(Control).MaxLength := Value;
end;

procedure TPressMVPEditView.SetText(const Value: string);
begin
  TPressXCLCustomEditFriend(Control).Text := PressEncodeString(Value);
end;

procedure TPressMVPEditView.ViewChangeEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  Changed;
  if Assigned(FViewChangeEvent) then
    FViewChangeEvent(Sender);
end;

procedure TPressMVPEditView.ViewEnterEvent(Sender: TObject);
begin
  inherited;
  Control.SelectAll;
end;

{ TPressMVPDateTimeView }

class function TPressMVPDateTimeView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomCalendar;
end;

function TPressMVPDateTimeView.GetAsDateTime: TDateTime;
begin
  Result := TPressXCLCustomCalendarFriend(Control).DateTime;
end;

function TPressMVPDateTimeView.GetAsString: string;
begin
  Result := PressDecodeString(TPressXCLCustomCalendarFriend(Control).Text);
end;

function TPressMVPDateTimeView.GetControl: TCustomCalendar;
begin
  Result := inherited Control as TCustomCalendar;
end;

function TPressMVPDateTimeView.GetIsClear: Boolean;
begin
  Result := TPressXCLCustomCalendarFriend(Control).DateTime = 0;
end;

procedure TPressMVPDateTimeView.InternalClear;
begin
  TPressXCLCustomCalendarFriend(Control).DateTime := 0;
end;

procedure TPressMVPDateTimeView.InternalUpdate;
begin
  inherited;
  if AccessMode = amInvisible then
    TPressXCLCustomCalendarFriend(Control).DateTime := 0
  else
    TPressXCLCustomCalendarFriend(Control).DateTime :=
     Model.Subject.AsDateTime;
  Control.Enabled := AccessMode = amWritable;
  Unchanged;
end;

procedure TPressMVPDateTimeView.ViewClickEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  Changed;
  inherited;
end;

{ TPressMVPBooleanView }

procedure TPressMVPBooleanView.ViewClickEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  Changed;
  inherited;
end;

{ TPressMVPCheckBoxView }

class function TPressMVPCheckBoxView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomCheckBox;
end;

function TPressMVPCheckBoxView.GetAsBoolean: Boolean;
begin
  Result := TPressXCLCustomCheckBoxFriend(Control).Checked;
end;

function TPressMVPCheckBoxView.GetControl: TCustomCheckBox;
begin
  Result := inherited Control as TCustomCheckBox;
end;

function TPressMVPCheckBoxView.GetIsClear: Boolean;
begin
  Result := TPressXCLCustomCheckBoxFriend(Control).State = cbGrayed;
end;

procedure TPressMVPCheckBoxView.InternalClear;
begin
  TPressXCLCustomCheckBoxFriend(Control).State := cbUnchecked;
end;

procedure TPressMVPCheckBoxView.InternalUpdate;
var
  VAttribute: TPressAttribute;
begin
  inherited;
  VAttribute := Model.Subject;
  { TODO : Implement invisibility }
  if VAttribute.IsNull then
    TPressXCLCustomCheckBoxFriend(Control).State := cbGrayed
  else if VAttribute.AsBoolean then
    TPressXCLCustomCheckBoxFriend(Control).State := cbChecked
  else
    TPressXCLCustomCheckBoxFriend(Control).State := cbUnchecked;
  Control.Enabled := AccessMode = amWritable;
  Unchanged;
end;

{ TPressMVPItemView }

procedure TPressMVPItemView.AddReference(const ACaption: string);
begin
  InternalAddReference(ACaption);
end;

procedure TPressMVPItemView.AssignReferences(AItems: TStrings);
var
  I: Integer;
begin
  InternalClearReferences;
  for I := 0 to Pred(AItems.Count) do
    InternalAddReference(AItems[I]);
end;

procedure TPressMVPItemView.ClearReferences;
begin
  InternalClearReferences;
end;

function TPressMVPItemView.GetReferencesVisible: Boolean;
begin
  Result := False;
end;

function TPressMVPItemView.GetSelectedText: string;
begin
  Result := '';
end;

procedure TPressMVPItemView.ViewEnterEvent(Sender: TObject);
begin
  InternalClearReferences;
  inherited;
end;

procedure TPressMVPItemView.ViewExitEvent(Sender: TObject);
begin
  InternalClearReferences;
  inherited;
end;

{ TPressMVPComboBoxView }

class function TPressMVPComboBoxView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomComboBox;
end;

function TPressMVPComboBoxView.GetAsInteger: Integer;
begin
  if Control.Items.Count = 0 then
    Result := -1
  else
    Result := Control.ItemIndex;
end;

function TPressMVPComboBoxView.GetAsString: string;
begin
  Result := PressDecodeString(TPressXCLCustomComboBoxFriend(Control).Text);
end;

function TPressMVPComboBoxView.GetControl: TCustomComboBox;
begin
  Result := inherited Control as TCustomComboBox;
end;

function TPressMVPComboBoxView.GetIsClear: Boolean;
begin
  Result := AsString = '';
end;

function TPressMVPComboBoxView.GetReferencesVisible: Boolean;
begin
  Result := Control.DroppedDown;
end;

function TPressMVPComboBoxView.GetSelectedText: string;
begin
  Result := Control.SelText;
end;

procedure TPressMVPComboBoxView.HideReferences;
begin
  Control.DroppedDown := False;
end;

procedure TPressMVPComboBoxView.InitView;
begin
  inherited;
  with TPressXCLCustomComboBoxFriend(Control) do
  begin
    FViewChangeEvent := OnChange;
    FViewDrawItemEvent := OnDrawItem;
    FViewDropDownEvent := OnDropDown;
    {$IFDEF FPC}
    FViewSelectEvent := OnSelect;
    {$ENDIF}
    OnChange := {$IFDEF FPC}@{$ENDIF}ViewChangeEvent;
    OnDrawItem := {$IFDEF FPC}@{$ENDIF}ViewDrawItemEvent;
    OnDropDown := {$IFDEF FPC}@{$ENDIF}ViewDropDownEvent;
    {$IFDEF FPC}
    OnSelect := {$IFDEF FPC}@{$ENDIF}ViewSelectEvent;
    {$ENDIF}
  end;
end;

procedure TPressMVPComboBoxView.InternalAddReference(const ACaption: string);
begin
  Control.Items.Add(PressEncodeString(ACaption));
end;

procedure TPressMVPComboBoxView.InternalClear;
begin
  ClearReferences;
  TPressXCLCustomComboBoxFriend(Control).Text := '';
  Changed;
end;

procedure TPressMVPComboBoxView.InternalClearReferences;
begin
  Control.Items.Clear;
end;

procedure TPressMVPComboBoxView.InternalUpdate;
begin
  inherited;
  if AccessMode = amInvisible then
    TPressXCLCustomComboBoxFriend(Control).Text := ''
  else
    TPressXCLCustomComboBoxFriend(Control).Text := PressEncodeString(Model.AsString);
  Control.Enabled := AccessMode = amWritable;
  Unchanged;
end;

procedure TPressMVPComboBoxView.ReleaseControl;
begin
  with TPressXCLCustomComboBoxFriend(Control) do
  begin
    OnChange := FViewChangeEvent;
    OnDrawItem := FViewDrawItemEvent;
    OnDropDown := FViewDropDownEvent;
  end;
  inherited;
end;

procedure TPressMVPComboBoxView.SelectAll;
begin
  Control.SelectAll;
end;

procedure TPressMVPComboBoxView.SetSize(Value: Integer);
begin
  TPressXCLCustomComboBoxFriend(Control).MaxLength := Value;
end;

procedure TPressMVPComboBoxView.ShowReferences;
begin
  DisableEvents;
  try
    Control.DroppedDown := False;
    Control.DroppedDown := True;
    Control.SelectAll;
  finally
    EnableEvents;
  end;
end;

procedure TPressMVPComboBoxView.ViewChangeEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  Changed;
  if Assigned(FViewChangeEvent) then
    FViewChangeEvent(Sender);
end;

{$IFDEF BORLAND_CG}
procedure TPressMVPComboBoxView.ViewClickEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  Changed;
  TPressMVPViewSelectEvent.Create(Self).Notify;
  inherited;
end;
{$ENDIF}

procedure TPressMVPComboBoxView.ViewDrawItemEvent(AControl: TWinControl;
  AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewDrawItemEvent.Create(
   Self, Control.Canvas, AIndex, TPressRect(ARect)).Notify;
  if Assigned(FViewDrawItemEvent) then
    FViewDrawItemEvent(Control, AIndex, ARect, AState);
end;

procedure TPressMVPComboBoxView.ViewDropDownEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewDropDownEvent.Create(Self).Notify;
  if Assigned(FViewDropDownEvent) then
    FViewDropDownEvent(Sender);
end;

{$IFDEF FPC}
procedure TPressMVPComboBoxView.ViewSelectEvent(Sender: TObject);
begin
  if EventsDisabled then
    Exit;
  Changed;
  TPressMVPViewSelectEvent.Create(Self).Notify;
  if Assigned(FViewSelectEvent) then
    FViewSelectEvent(Sender);
end;
{$ENDIF}

{ TPressMVPItemsView }

function TPressMVPItemsView.CurrentItem: Integer;
begin
  Result := InternalCurrentItem;
end;

function TPressMVPItemsView.GetModel: TPressMVPItemsModel;
begin
  Result := inherited Model as TPressMVPItemsModel;
end;

function TPressMVPItemsView.GetRowCount: Integer;
begin
  Result := InternalGetRowCount;
end;

procedure TPressMVPItemsView.InternalSetColumnCount(AColumnCount: Integer);
begin
end;

procedure TPressMVPItemsView.InternalSetColumnWidth(AColumn, AWidth: Integer);
begin
end;

procedure TPressMVPItemsView.InternalUpdate;
begin
  inherited;
  RowCount := Model.Count;
  Control.Enabled := AccessMode = amWritable;
  { TODO : Improve }
  Control.Invalidate;
end;

procedure TPressMVPItemsView.SelectItem(AIndex: Integer);
var
  VRowCount: Integer;
begin
  { TODO : Improve }
  VRowCount := RowCount;
  if AIndex = VRowCount then
    RowCount := VRowCount + 1;
  InternalSelectItem(AIndex);
end;

procedure TPressMVPItemsView.SetRowCount(ARowCount: Integer);
begin
  InternalSetRowCount(ARowCount);
end;

{ TPressMVPListBoxView }

class function TPressMVPListBoxView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomListBox;
end;

function TPressMVPListBoxView.GetControl: TCustomListBox;
begin
  Result := inherited Control as TCustomListBox;
end;

procedure TPressMVPListBoxView.InitView;
begin
  inherited;
  with TPressXCLCustomListBoxFriend(Control) do
  begin
    FViewDrawItemEvent := OnDrawItem;
    OnDrawItem := {$IFDEF FPC}@{$ENDIF}ViewDrawItemEvent;
    Style := lbOwnerDrawFixed;
    { TODO : Implement multi selection }
    MultiSelect := False; //True;
  end;
end;

function TPressMVPListBoxView.InternalCurrentItem: Integer;
begin
  Result := Control.ItemIndex;
end;

function TPressMVPListBoxView.InternalGetRowCount: Integer;
begin
  Result := Control.Items.Count;
end;

procedure TPressMVPListBoxView.InternalSelectItem(AIndex: Integer);
begin
  Control.ItemIndex := AIndex;
end;

procedure TPressMVPListBoxView.InternalSetRowCount(ARowCount: Integer);
var
  VStrings: TStrings;
begin
  VStrings := Control.Items;
  VStrings.BeginUpdate;
  try
    while VStrings.Count < ARowCount do
      VStrings.Add('');
    while VStrings.Count > ARowCount do
      VStrings.Delete(VStrings.Count - 1);
  finally
    VStrings.EndUpdate;
  end;
end;

procedure TPressMVPListBoxView.ReleaseControl;
begin
  with TPressXCLCustomListBoxFriend(Control) do
  begin
    OnDrawItem := FViewDrawItemEvent;
  end;
  inherited;
end;

procedure TPressMVPListBoxView.ViewDrawItemEvent(AControl: TWinControl;
  AIndex: Integer; ARect: TRect; AState: TOwnerDrawState);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewDrawItemEvent.Create(
   Self, Control.Canvas, AIndex, TPressRect(ARect)).Notify;
  if Assigned(FViewDrawItemEvent) then
    FViewDrawItemEvent(Control, AIndex, ARect, AState);
end;

{ TPressMVPGridView }

procedure TPressMVPGridView.AlignColumns;
begin
  InternalAlignColumns;
end;

class function TPressMVPGridView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomDrawGrid;
end;

function TPressMVPGridView.GetControl: TCustomDrawGrid;
begin
  Result := inherited Control as TCustomDrawGrid;
end;

procedure TPressMVPGridView.InitView;
begin
  inherited;
  with Control do
  begin
    FViewDrawCellEvent := OnDrawCell;
    OnDrawCell := {$IFDEF FPC}@{$ENDIF}ViewDrawCellEvent;
    Options := Options +
     [goColSizing, goRowSelect] - [goHorzLine, goRangeSelect];
  end;
end;

procedure TPressMVPGridView.InternalAlignColumns;
var
  VControl: TCustomDrawGrid;
  VColCount, VClientWidth, VTotalWidth, VWidth, VDiff, VDelta: Integer;
  I: Integer;
begin
  VControl := Control;
  VColCount := VControl.ColCount;
  if VColCount < 2 then
    Exit;
  VClientWidth := VControl.ClientWidth - VControl.ColWidths[0] - VColCount;
  VTotalWidth := 0;
  for I := 1 to Pred(VColCount) do
    VTotalWidth := VTotalWidth + VControl.ColWidths[I];
  VDiff := VTotalWidth - VClientWidth;
  for I := 1 to Pred(VColCount) do
  begin
    VWidth := VControl.ColWidths[I];
    VDelta := Round(VDiff * VWidth / VTotalWidth);
    VControl.ColWidths[I] := VWidth - VDelta;
    VTotalWidth := VTotalWidth - VWidth;
    VDiff := VDiff - VDelta;
  end;
end;

function TPressMVPGridView.InternalCurrentItem: Integer;
begin
  Result := Control.Row - 1;
end;

function TPressMVPGridView.InternalGetRowCount: Integer;
begin
  Result := Control.RowCount - 1;
end;

procedure TPressMVPGridView.InternalReset;
var
  VColumnData: TPressMVPColumnData;
  I: Integer;
begin
  with Control do
  begin
    DefaultRowHeight := 16;
    VColumnData := Model.ColumnData;
    ColCount := VColumnData.ColumnCount + 1;
    for I := 0 to Pred(VColumnData.ColumnCount) do
      ColWidths[I + 1] := VColumnData[I].Width;
    if ColCount > 1 then
    begin
      ColWidths[0] := 26;
      FixedCols := 1;
    end;
    if RowCount < 2 then
      RowCount := 2;
    FixedRows := 1;
    AlignColumns;
  end;
  inherited;
end;

procedure TPressMVPGridView.InternalSelectItem(AIndex: Integer);
begin
  Control.Row := AIndex + 1;
end;

procedure TPressMVPGridView.InternalSetColumnCount(AColumnCount: Integer);
begin
  if AColumnCount > 0 then
    Control.ColCount := AColumnCount + 1
  else
    Control.ColCount := 2;
end;

procedure TPressMVPGridView.InternalSetColumnWidth(AColumn, AWidth: Integer);
begin
  Control.ColWidths[AColumn + 1] := AWidth;
end;

procedure TPressMVPGridView.InternalSetRowCount(ARowCount: Integer);
begin
  if ARowCount > 0 then
    Control.RowCount := ARowCount + 1
  else
    Control.RowCount := 2;
end;

procedure TPressMVPGridView.ReleaseControl;
begin
  with Control do
  begin
    OnDrawCell := FViewDrawCellEvent;
  end;
  inherited;
end;

procedure TPressMVPGridView.ViewDrawCellEvent(
  Sender: TObject; ACol, ARow: Integer;
  ARect: TRect; State: TGridDrawState);
begin
  if EventsDisabled then
    Exit;
  TPressMVPViewDrawCellEvent.Create(
   Self, Control.Canvas, ACol - 1, ARow - 1, TPressRect(ARect)).Notify;
  if Assigned(FViewDrawCellEvent) then
    FViewDrawCellEvent(Sender, ACol, ARow, ARect, State);
end;

procedure TPressMVPGridView.ViewMouseUpEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  VCol, VRow: Integer;
begin
  if EventsDisabled then
    Exit;
  inherited;
  Control.MouseToCell(X, Y, VCol, VRow);
  Dec(VCol);
  Dec(VRow);
  if VRow < 0 then
    TPressMVPViewClickHeaderEvent.Create(Self{, Button, Shift, VCol}).Notify
  else
    TPressMVPViewClickCellEvent.Create(Self{, Button, Shift, VCol, VRow}).Notify;
end;

{ TPressMVPCaptionView }

function TPressMVPCaptionView.GetAsString: string;
begin
  Result := PressDecodeString(TPressXCLControlFriend(Control).Caption);
end;

procedure TPressMVPCaptionView.InternalUpdate;
begin
  inherited;
  if AccessMode = amInvisible then
    TPressXCLControlFriend(Control).Caption := ''
  else
    TPressXCLControlFriend(Control).Caption := PressEncodeString(Model.AsString);
end;

procedure TPressMVPCaptionView.SetText(const Value: string);
begin
  TPressXCLControlFriend(Control).Caption := PressEncodeString(Value);
end;

{ TPressMVPLabelView }

class function TPressMVPLabelView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomLabel;
end;

{ TPressMVPPanelView }

class function TPressMVPPanelView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomPanel;
end;

{ TPressMVPPictureView }

class function TPressMVPPictureView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TImage;
end;

function TPressMVPPictureView.GetControl: TImage;
begin
  Result := inherited Control as TImage;
end;

procedure TPressMVPPictureView.InternalUpdate;
var
  VSubject: TPressAttribute;
begin
  inherited;
  VSubject := Model.Subject;
  if VSubject is TPressPicture then
    TPressPicture(VSubject).AssignToPicture(Control.Picture);
end;

{ TPressMVPCustomFormView }

function TPressMVPCustomFormView.ComponentByName(
  const AComponentName: ShortString): TObject;
begin
  Result := Control.FindComponent(AComponentName);
  if not Assigned(Result) then
    raise EPressMVPError.CreateFmt(SComponentNotFound,
     [Control.Name, AComponentName]);
end;

function TPressMVPCustomFormView.GetControl: TCustomForm;
begin
  Result := inherited Control as TCustomForm;
end;

{ TPressMVPFormView }

class function TPressMVPFormView.Apply(AControl: TObject): Boolean;
begin
  Result := AControl is TCustomForm;
end;

procedure TPressMVPFormView.Close;
begin
  Control.Close;
end;

function TPressMVPFormView.GetText: string;
begin
  Result := Control.Caption;
end;

procedure TPressMVPFormView.InitView;
var
  VRect: TRect;
begin
  inherited;
  with TPressXCLCustomFormFriend(Control) do
  begin
    FViewCloseEvent := OnClose;
    OnClose := {$IFDEF FPC}@{$ENDIF}ViewCloseEvent;
{$IFDEF MSWINDOWS}
    { TODO : Improve, create a routine at Compatibility/Utils unit }
    if not SystemParametersInfo(SPI_GETWORKAREA, 0, @VRect, 0) then
{$ENDIF}
      VRect := Rect(0, 0, Screen.Width, Screen.Height);
    if Top + Height > VRect.Bottom then
      Top := Max(VRect.Top, VRect.Bottom - Height);
    if Left + Width > VRect.Right then
      Left := Max(VRect.Left, VRect.Right - Width);
  end;
end;

procedure TPressMVPFormView.ReleaseControl;
begin
  with TPressXCLCustomFormFriend(Control) do
  begin
    OnClose := FViewCloseEvent;
  end;
  inherited;
end;

procedure TPressMVPFormView.SetText(const Value: string);
begin
  Control.Caption := PressEncodeString(Value);
end;

procedure TPressMVPFormView.ViewCloseEvent(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FViewCloseEvent) then
    FViewCloseEvent(Sender, Action);
  if Action = caFree then
    ReleaseControl;
  { TODO : Check AV when Action = caFree due to queue notification }
  TPressMVPViewCloseFormEvent.Create(Self).Notify;
end;

initialization
  PressRegisterWidgetManager(TPressMVPWidgetManager.Create);
  TPressMVPEditView.RegisterView;
  TPressMVPDateTimeView.RegisterView;
  TPressMVPCheckBoxView.RegisterView;
  TPressMVPListBoxView.RegisterView;
  TPressMVPComboBoxView.RegisterView;
  TPressMVPGridView.RegisterView;
  TPressMVPLabelView.RegisterView;
  TPressMVPPanelView.RegisterView;
  TPressMVPPictureView.RegisterView;
  TPressMVPFormView.RegisterView;

end.
