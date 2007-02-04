(*
  PressObjects, Attribute Classes
  Copyright (C) 2006-2007 Laserpress Ltda.

  http://www.pressobjects.org

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit PressAttributes;

{$I Press.inc}

interface

uses
  Classes,
  PressClasses,
  PressSubject,
  Graphics;

type
  { Memento declarations }

  TPressValue = class;

  TPressValueMemento = class(TPressAttributeMemento)
  private
    FAttributeClone: TPressValue;
  protected
    procedure Modifying; override;
    procedure Restore; override;
    property AttributeClone: TPressValue read FAttributeClone;
  public
    destructor Destroy; override;
  end;

  TPressItemState = (isUnmodified, isAdded, isModified, isDeleted);

  TPressItemMementoList = class;

  TPressItemMemento = class(TPressAttributeMemento)
  private
    FOldIndex: Integer;
    FOwnerList: TPressItemMementoList;
    FProxy: TPressProxy;
    FProxyClone: TPressProxy;
    FState: TPressItemState;
    FSubjectMemento: TPressObjectMemento;
  protected
    procedure Init; override;
    procedure ItemAdded;
    procedure ItemDeleted(AOldIndex: Integer);
    procedure Modifying; override;
    procedure ReleaseItem;
    procedure Restore; override;
    property OldIndex: Integer read FOldIndex;
    property Proxy: TPressProxy read FProxy;
    property State: TPressItemState read FState;
    property SubjectMemento: TPressObjectMemento read FSubjectMemento;
  public
    constructor Create(AOwner: TPressStructure; AProxy: TPressProxy);
    destructor Destroy; override;
  end;

  TPressItemMementoIterator = class;

  TPressItemMementoList = class(TPressList)
  private
    function GetItems(AIndex: Integer): TPressItemMemento;
    procedure SetItems(AIndex: Integer; Value: TPressItemMemento);
  protected
    function InternalCreateIterator: TPressCustomIterator; override;
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function Add(AObject: TPressItemMemento): Integer;
    function AddItem(AOwner: TPressStructure; AProxy: TPressProxy): TPressItemMemento;
    function CreateIterator: TPressItemMementoIterator;
    function Extract(AObject: TPressItemMemento): TPressItemMemento;
    function IndexOf(AObject: TPressItemMemento): Integer;
    function IndexOfProxy(AProxy: TPressProxy): Integer;
    procedure Insert(Index: Integer; AObject: TPressItemMemento);
    function Remove(AObject: TPressItemMemento): Integer;
    property Items[AIndex: Integer]: TPressItemMemento read GetItems write SetItems; default;
  end;

  TPressItemMementoIterator = class(TPressIterator)
  private
    function GetCurrentItem: TPressItemMemento;
  public
    property CurrentItem: TPressItemMemento read GetCurrentItem;
  end;

  TPressItems = class;

  TPressItemsMemento = class(TPressAttributeMemento)
  private
    FItems: TPressItemMementoList;
    function GetItems: TPressItemMementoList;
    function GetOwner: TPressItems;
  protected
    procedure Notify(AProxy: TPressProxy; AItemState: TPressItemState; AOldIndex: Integer = -1);
    procedure Restore; override;
    property Items: TPressItemMementoList read GetItems;
    property Owner: TPressItems read GetOwner;
  public
    constructor Create(AOwner: TPressItems);
    destructor Destroy; override;
  end;

  TPressItemsMementoIterator = class;

  TPressItemsMementoList = class(TPressList)
  private
    function GetItems(AIndex: Integer): TPressItemsMemento;
    procedure SetItems(AIndex: Integer; Value: TPressItemsMemento);
  protected
    function InternalCreateIterator: TPressCustomIterator; override;
  public
    function Add(AObject: TPressItemsMemento): Integer;
    function CreateIterator: TPressItemsMementoIterator;
    function Extract(AObject: TPressItemsMemento): TPressItemsMemento;
    function IndexOf(AObject: TPressItemsMemento): Integer;
    procedure Insert(Index: Integer; AObject: TPressItemsMemento);
    function Remove(AObject: TPressItemsMemento): Integer;
    property Items[AIndex: Integer]: TPressItemsMemento read GetItems write SetItems; default;
  end;

  TPressItemsMementoIterator = class(TPressIterator)
  private
    function GetCurrentItem: TPressItemsMemento;
  public
    property CurrentItem: TPressItemsMemento read GetCurrentItem;
  end;

  { Value attributes declarations }

  TPressValue = class(TPressAttribute)
  protected
    function GetSignature: string; override;
    function InternalCreateMemento: TPressAttributeMemento; override;
  end;

  TPressString = class(TPressValue)
  private
    FValue: string;
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsDate: TDate; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: string; override;
    function GetAsTime: TTime; override;
    function GetAsVariant: Variant; override;
    function GetIsEmpty: Boolean; override;
    function GetValue: string; virtual;
    procedure SetAsBoolean(AValue: Boolean); override;
    procedure SetAsDate(AValue: TDate); override;
    procedure SetAsDateTime(AValue: TDateTime); override;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsInteger(AValue: Integer); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsTime(AValue: TTime); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(const AValue: string); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: string read GetValue write SetValue;
  end;

  TPressNumeric = class(TPressValue)
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsDate: TDate; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsTime: TTime; override;
    function GetDisplayText: string; override;
    procedure SetAsBoolean(AValue: Boolean); override;
    procedure SetAsDate(AValue: TDate); override;
    procedure SetAsDateTime(AValue: TDateTime); override;
    procedure SetAsTime(AValue: TTime); override;
  end;

  TPressInteger = class(TPressNumeric)
  private
    FValue: Integer;
  protected
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: string; override;
    function GetAsVariant: Variant; override;
    function GetIsEmpty: Boolean; override;
    function GetValue: Integer; virtual;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsInteger(AValue: Integer); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: Integer); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: Integer read GetValue write SetValue;
  end;

  TPressFloat = class(TPressNumeric)
  private
    FValue: Double;
  protected
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: string; override;
    function GetAsVariant: Variant; override;
    function GetIsEmpty: Boolean; override;
    function GetValue: Double; virtual;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsInteger(AValue: Integer); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: Double); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: Double read GetValue write SetValue;
  end;

  TPressCurrency = class(TPressNumeric)
  private
    FValue: Currency;
  protected
    function GetAsCurrency: Currency; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: string; override;
    function GetAsVariant: Variant; override;
    function GetIsEmpty: Boolean; override;
    function GetDisplayText: string; override;
    function GetValue: Currency; virtual;
    procedure SetAsCurrency(AValue: Currency); override;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsInteger(AValue: Integer); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: Currency); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: Currency read GetValue write SetValue;
  end;

  TPressEnum = class(TPressValue)
  private
    FValue: Integer;
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsDate: TDate; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: string; override;
    function GetAsTime: TTime; override;
    function GetAsVariant: Variant; override;
    function GetIsEmpty: Boolean; override;
    function GetValue: Integer; virtual;
    procedure SetAsBoolean(AValue: Boolean); override;
    procedure SetAsDate(AValue: TDate); override;
    procedure SetAsDateTime(AValue: TDateTime); override;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsInteger(AValue: Integer); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsTime(AValue: TTime); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: Integer); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: Integer read GetValue write SetValue;
  end;

  TPressBoolean = class(TPressValue)
  private
    FValue: Boolean;
    FValues: array[Boolean] of string;
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: string; override;
    function GetAsVariant: Variant; override;
    function GetDisplayText: string; override;
    function GetValue: Boolean; virtual;
    procedure Initialize; override;
    procedure SetAsBoolean(AValue: Boolean); override;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsInteger(AValue: Integer); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: Boolean); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: Boolean read GetValue write SetValue;
  end;

  TPressDate = class(TPressValue)
  private
    FValue: TDate;
  protected
    function GetAsDate: TDate; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsString: string; override;
    function GetAsTime: TTime; override;
    function GetAsVariant: Variant; override;
    function GetDisplayText: string; override;
    function GetValue: TDate; virtual;
    procedure Initialize; override;
    procedure SetAsDate(AValue: TDate); override;
    procedure SetAsDateTime(AValue: TDateTime); override;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsTime(AValue: TTime); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: TDate); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: TDate read GetValue write SetValue;
  end;

  TPressTime = class(TPressValue)
  private
    FValue: TTime;
  protected
    function GetAsDate: TDate; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsString: string; override;
    function GetAsTime: TTime; override;
    function GetAsVariant: Variant; override;
    function GetDisplayText: string; override;
    function GetValue: TTime; virtual;
    procedure Initialize; override;
    procedure SetAsDate(AValue: TDate); override;
    procedure SetAsDateTime(AValue: TDateTime); override;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsTime(AValue: TTime); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: TTime); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: TTime read GetValue write SetValue;
  end;

  TPressDateTime = class(TPressValue)
  private
    FValue: TDateTime;
  protected
    function GetAsDate: TDate; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsString: string; override;
    function GetAsTime: TTime; override;
    function GetAsVariant: Variant; override;
    function GetDisplayText: string; override;
    function GetValue: TDateTime; virtual;
    procedure Initialize; override;
    procedure SetAsDate(AValue: TDate); override;
    procedure SetAsDateTime(AValue: TDateTime); override;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsTime(AValue: TTime); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: TDateTime); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: TDateTime read GetValue write SetValue;
  end;

  TPressVariant = class(TPressValue)
  private
    FValue: Variant;
  protected
    function GetAsBoolean: Boolean; override;
    function GetAsDate: TDate; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsFloat: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsString: string; override;
    function GetAsTime: TTime; override;
    function GetAsVariant: Variant; override;
    function GetValue: Variant; virtual;
    procedure SetAsBoolean(AValue: Boolean); override;
    procedure SetAsDate(AValue: TDate); override;
    procedure SetAsDateTime(AValue: TDateTime); override;
    procedure SetAsFloat(AValue: Double); override;
    procedure SetAsInteger(AValue: Integer); override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsTime(AValue: TTime); override;
    procedure SetAsVariant(AValue: Variant); override;
    procedure SetValue(AValue: Variant); virtual;
  public
    procedure Assign(Source: TPersistent); override;
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure Reset; override;
    property Value: Variant read GetValue write SetValue;
  end;

  TPressBlob = class(TPressValue)
  private
    FStream: TMemoryStream;
    function GetSize: Integer;
    function GetStream: TMemoryStream;
    function GetValue: string;
    procedure SetValue(const AValue: string);
  protected
    procedure Finit; override;
    function GetAsString: string; override;
    function GetAsVariant: Variant; override;
    procedure SetAsString(const AValue: string); override;
    procedure SetAsVariant(AValue: Variant); override;
    property Stream: TMemoryStream read GetStream;
  public
    procedure Assign(Source: TPersistent); override;
    procedure ClearBuffer;
    procedure LoadFromStream(AStream: TStream);
    procedure Reset; override;
    procedure SaveToStream(AStream: TStream);
    function WriteBuffer(const ABuffer; ACount: Integer): Boolean;
    property Size: Integer read GetSize;
    property Value: string read GetValue write SetValue;
  end;

  TPressMemo = class(TPressBlob)
  public
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
  end;

  TPressBinary = class(TPressBlob)
  public
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
  end;

  TPressPicture = class(TPressBlob)
  private
    function GetHasPicture: Boolean;
  public
    procedure AssignPicture(APicture: TPicture);
    procedure AssignPictureFromFile(const AFileName: string);
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
    procedure ClearPicture;
    property HasPicture: Boolean read GetHasPicture;
  end;

  { Structured attributes declarations }

  TPressItem = class(TPressStructure)
  private
    FProxy: TPressProxy;
    function GetObjectClassName: string;
    function GetObjectId: string;
    function GetProxy: TPressProxy;
    function GetValue: TPressObject;
    procedure SetValue(AValue: TPressObject);
  protected
    procedure Finit; override;
    function GetIsEmpty: Boolean; override;
    function GetSignature: string; override;
    procedure InternalAssignObject(AObject: TPressObject); override;
    function InternalCreateMemento: TPressAttributeMemento; override;
    procedure InternalUnassignObject(AObject: TPressObject); override;
    property Proxy: TPressProxy read GetProxy;
  public
    procedure Assign(Source: TPersistent); override;
    procedure AssignReference(const AClassName, AId: string);
    function HasInstance: Boolean;
    procedure Reset; override;
    function SameReference(AObject: TPressObject): Boolean; overload;
    function SameReference(const ARefClass, ARefID: string): Boolean; overload;
    property ObjectClassName: string read GetObjectClassName;
    property ObjectId: string read GetObjectId;
    property Value: TPressObject read GetValue write SetValue;
  end;

  TPressPart = class(TPressItem)
  protected
    procedure AfterChangeItem(AItem: TPressObject); override;
    procedure BeforeChangeInstance(Sender: TPressProxy; Instance: TPressObject; ChangeType: TPressProxyChangeType); override;
    procedure BeforeChangeItem(AItem: TPressObject); override;
    procedure BeforeRetrieveInstance(Sender: TPressProxy); override;
    procedure BindInstance(AInstance: TPressObject); override;
    procedure InternalAssignItem(AProxy: TPressProxy); override;
    function InternalProxyType: TPressProxyType; override;
    procedure ReleaseInstance(AInstance: TPressObject); override;
  public
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
  end;

  TPressReference = class(TPressItem)
  protected
    procedure AfterChangeItem(AItem: TPressObject); override;
    procedure InternalAssignItem(AProxy: TPressProxy); override;
    function InternalProxyType: TPressProxyType; override;
  public
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
  end;

  TPressItemsEventType =
   (ietAdd, ietInsert, ietModify, ietNotify, ietRemove, ietRebuild, ietClear);

  TPressItemsChangedEvent = class(TPressAttributeChangedEvent)
  private
    FEventType: TPressItemsEventType;
    FIndex: Integer;
    FProxy: TPressProxy;
  public
    constructor Create(AOwner: TObject; AProxy: TPressProxy; AIndex: Integer; AEventType: TPressItemsEventType);
    property EventType: TPressItemsEventType read FEventType;
    property Index: Integer read FIndex;
    property Proxy: TPressProxy read FProxy;
  end;

  TPressItemsIterator = class;

  TPressItems = class(TPressStructure)
  private
    FMementos: TPressItemsMementoList;
    FProxyDeletedList: TPressProxyList;
    FProxyList: TPressProxyList;
    function GetHasAddedItem: Boolean;
    function GetHasDeletedItem: Boolean;
    function GetMementos: TPressItemsMementoList;
    function GetObjects(AIndex: Integer): TPressObject;
    function GetProxies(AIndex: Integer): TPressProxy;
    function GetProxyDeletedList: TPressProxyList;
    function GetProxyList: TPressProxyList;
    procedure SetObjects(AIndex: Integer; AValue: TPressObject);
  protected
    procedure AfterChangeInstance(Sender: TPressProxy; Instance: TPressObject; ChangeType: TPressProxyChangeType); override;
    procedure ChangedItem(AItem: TPressObject; ASubjectChanged: Boolean = True);
    procedure ChangedList(Sender: TPressProxyList; Item: TPressProxy; Action: TListNotification);
    procedure Finit; override;
    function GetIsEmpty: Boolean; override;
    procedure InternalAssignObject(AObject: TPressObject); override;
    function InternalCreateIterator: TPressItemsIterator; virtual;
    function InternalCreateMemento: TPressAttributeMemento; override;
    procedure InternalUnassignObject(AObject: TPressObject); override;
    procedure NotifyMementos(AProxy: TPressProxy; AItemState: TPressItemState; AOldIndex: Integer = -1);
    procedure NotifyRebuild;
    property Mementos: TPressItemsMementoList read GetMementos;
    property ProxyDeletedList: TPressProxyList read GetProxyDeletedList;
    property ProxyList: TPressProxyList read GetProxyList;
    (*
    function InternalCreateIterator: TPressItemsIterator; override;
    *)
  public
    function Add(AObject: TPressObject): Integer;
    function AddReference(const AClassName, AId: string): Integer;
    procedure Assign(Source: TPersistent); override;
    procedure AssignProxyList(AProxyList: TPressProxyList);
    { TODO : Refactor Clear, move to virtual Reset }
    procedure Clear;
    function Count: Integer;
    function CreateIterator: TPressItemsIterator;
    function CreateProxyIterator: TPressProxyIterator;
    procedure Delete(AIndex: Integer);
    function IndexOf(AObject: TPressObject): Integer;
    procedure Insert(AIndex: Integer; AObject: TPressObject);
    function Remove(AObject: TPressObject): Integer;
    property HasAddedItem: Boolean read GetHasAddedItem;
    property HasDeletedItem: Boolean read GetHasDeletedItem;
    property Objects[AIndex: Integer]: TPressObject read GetObjects write SetObjects; default;
    property Proxies[AIndex: Integer]: TPressProxy read GetProxies;
    (*
    function Add(AObject: TPressObject): Integer;
    function CreateIterator: TPressItemsIterator;
    function IndexOf(AObject: TPressObject): Integer;
    procedure Insert(AIndex: Integer; AObject: TPressObject);
    function Remove(AObject: TPressObject): Integer;
    class function ValidObjectClass: TPressObjectClass; override;
    property Objects[AIndex: Integer]: TPressObject read GetObjects write SetObjects; default;
    *)
  end;

  TPressItemsIterator = class(TPressProxyIterator)
  private
    function GetCurrentItem: TPressObject;
  public
    property CurrentItem: TPressObject read GetCurrentItem;
    (*
    property CurrentItem: TPressObject read GetCurrentItem;
    *)
  end;

  TPressParts = class(TPressItems)
  protected
    procedure AfterChangeItem(AItem: TPressObject); override;
    procedure BeforeChangeInstance(Sender: TPressProxy; Instance: TPressObject; ChangeType: TPressProxyChangeType); override;
    procedure BeforeChangeItem(AItem: TPressObject); override;
    procedure BeforeRetrieveInstance(Sender: TPressProxy); override;
    procedure BindInstance(AInstance: TPressObject); override;
    procedure InternalAssignItem(AProxy: TPressProxy); override;
    function InternalProxyType: TPressProxyType; override;
    procedure ReleaseInstance(AInstance: TPressObject); override;
  public
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
  end;

  TPressReferences = class(TPressItems)
  protected
    procedure AfterChangeItem(AItem: TPressObject); override;
    procedure InternalAssignItem(AProxy: TPressProxy); override;
    function InternalProxyType: TPressProxyType; override;
  public
    class function AttributeBaseType: TPressAttributeBaseType; override;
    class function AttributeName: string; override;
  end;

implementation

uses
  SysUtils,
  {$IFDEF PressLog}PressLog,{$ENDIF}
  PressConsts;

type
  TPressObjectFriend = class(TPressObject);

{ TPressValueMemento }

destructor TPressValueMemento.Destroy;
begin
  FAttributeClone.Free;
  inherited;
end;

procedure TPressValueMemento.Modifying;
begin
  inherited;
  FAttributeClone.Free;
  FAttributeClone := Owner.Clone as TPressValue;
end;

procedure TPressValueMemento.Restore;
begin
  if Assigned(FAttributeClone) then
  begin
    {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, Format('Restoring %s (%s)', [Owner.Signature, FAttributeClone.Signature]));{$ENDIF}
    Owner.Assign(FAttributeClone);
  end;
  RestoreChanged;
end;

{ TPressItemMemento }

constructor TPressItemMemento.Create(
  AOwner: TPressStructure; AProxy: TPressProxy);
begin
  inherited Create(AOwner);
  FProxy := AProxy;
  FProxy.AddRef;
end;

destructor TPressItemMemento.Destroy;
begin
  FProxy.Free;
  FProxyClone.Free;
  FSubjectMemento.Free;
  inherited;
end;

procedure TPressItemMemento.Init;
begin
  inherited;
  FState := isUnmodified;
end;

procedure TPressItemMemento.ItemAdded;
begin
  {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, 'Adding to ' + Owner.Signature);{$ENDIF}
  FState := isAdded;
end;

procedure TPressItemMemento.ItemDeleted(AOldIndex: Integer);
begin
  {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, 'Deleting from ' + Owner.Signature);{$ENDIF}
  if State = isAdded then
    ReleaseItem
  else
  begin
    FOldIndex := AOldIndex;
    FState := isDeleted;
  end;
end;

procedure TPressItemMemento.Modifying;
begin
  {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, 'Trying to modify item ' + Owner.Signature);{$ENDIF}
  if FState = isUnmodified then
  begin
    inherited;
    FProxyClone.Free;
    FProxyClone := FProxy.Clone;
    FreeAndNil(FSubjectMemento);
    if FProxy.HasInstance and (FProxy.ProxyType = ptOwned) then
      FSubjectMemento := FProxy.Instance.CreateMemento;
    FState := isModified;
  end;
end;

procedure TPressItemMemento.ReleaseItem;
begin
  if Assigned(FOwnerList) then
    FOwnerList.Extract(Self);
  Free;
end;

procedure TPressItemMemento.Restore;

  procedure RestoreAdded;
  begin
    {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, 'Restoring added to ' + Owner.Signature);{$ENDIF}
    (Owner as TPressItems).ProxyList.Remove(FProxy);  // friend class
  end;

  procedure RestoreModified;
  begin
    {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, 'Restoring modified ' + Owner.Signature);{$ENDIF}
    if Assigned(FProxyClone) then
      FProxy.Assign(FProxyClone);
    if Assigned(FSubjectMemento) then
      FSubjectMemento.Restore;
  end;

  procedure RestoreDeleted;
  var
    VProxyList: TPressProxyList;
  begin
    {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, 'Restoring deleted from ' + Owner.Signature);{$ENDIF}
    VProxyList := (Owner as TPressItems).ProxyList;  // friend class
    if (FOldIndex >= 0) and (FOldIndex < VProxyList.Count) then
      VProxyList.Insert(FOldIndex, FProxy)
    else
      VProxyList.Add(FProxy);
    FProxy.AddRef;
  end;

begin
  case State of
    isUnmodified:
      ;
    isAdded:
      RestoreAdded;
    isModified:
      RestoreModified;
    isDeleted:
      RestoreDeleted;
  end;
  if Owner is TPressItem then
    RestoreChanged;
end;

{ TPressItemMementoList }

function TPressItemMementoList.Add(AObject: TPressItemMemento): Integer;
begin
  Result := inherited Add(AObject);
end;

function TPressItemMementoList.AddItem(
  AOwner: TPressStructure; AProxy: TPressProxy): TPressItemMemento;
begin
  Result := TPressItemMemento.Create(AOwner, AProxy);
  try
    Add(Result);
  except
    Result.Free;
    raise;
  end;
end;

function TPressItemMementoList.CreateIterator: TPressItemMementoIterator;
begin
  Result := TPressItemMementoIterator.Create(Self);
end;

function TPressItemMementoList.Extract(
  AObject: TPressItemMemento): TPressItemMemento;
begin
  Result := inherited Extract(AObject) as TPressItemMemento;
end;

function TPressItemMementoList.GetItems(
  AIndex: Integer): TPressItemMemento;
begin
  Result := inherited Items[AIndex] as TPressItemMemento;
end;

function TPressItemMementoList.IndexOf(
  AObject: TPressItemMemento): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

function TPressItemMementoList.IndexOfProxy(AProxy: TPressProxy): Integer;
begin
  for Result := 0 to Pred(Count) do
    if Items[Result].Proxy = AProxy then
      Exit;
  Result := -1;
end;

procedure TPressItemMementoList.Insert(
  Index: Integer; AObject: TPressItemMemento);
begin
  inherited Insert(Index, AObject);
end;

function TPressItemMementoList.InternalCreateIterator: TPressCustomIterator;
begin
  Result := CreateIterator;
end;

procedure TPressItemMementoList.Notify(
  Ptr: Pointer; Action: TListNotification);
begin
  inherited;
  if Action = lnAdded then
    (TObject(Ptr) as TPressItemMemento).FOwnerList := Self;
end;

function TPressItemMementoList.Remove(AObject: TPressItemMemento): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TPressItemMementoList.SetItems(
  AIndex: Integer; Value: TPressItemMemento);
begin
  inherited Items[AIndex] := Value;
end;

{ TPressItemMementoIterator }

function TPressItemMementoIterator.GetCurrentItem: TPressItemMemento;
begin
  Result := inherited CurrentItem as TPressItemMemento;
end;

{ TPressItemsMemento }

constructor TPressItemsMemento.Create(AOwner: TPressItems);
begin
  inherited Create(AOwner);
end;

destructor TPressItemsMemento.Destroy;
begin
  Owner.Mementos.Extract(Self);
  FItems.Free;
  inherited;
end;

function TPressItemsMemento.GetItems: TPressItemMementoList;
begin
  if not Assigned(FItems) then
    FItems := TPressItemMementoList.Create(True);
  Result := FItems;
end;

function TPressItemsMemento.GetOwner: TPressItems;
begin
  Result := inherited Owner as TPressItems;
end;

procedure TPressItemsMemento.Notify(
  AProxy: TPressProxy; AItemState: TPressItemState; AOldIndex: Integer);
var
  VIndex: Integer;
  VItem: TPressItemMemento;
begin
  {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, 'Notifying ' + Owner.Signature);{$ENDIF}
  VIndex := Items.IndexOfProxy(AProxy);
  if VIndex = -1 then
    VItem := Items.AddItem(Owner, AProxy)
  else
    VItem := Items[VIndex];
  case AItemState of
    isAdded:
      VItem.ItemAdded;
    isModified:
      VItem.Modifying;
    isDeleted:
      VItem.ItemDeleted(AOldIndex);
  end;
end;

procedure TPressItemsMemento.Restore;
var
  I: Integer;
begin
  {$IFDEF PressLogSubjectMemento}PressLogMsg(Self, 'Restoring ' + Owner.Signature);{$ENDIF}
  Owner.DisableChanges;
  try
    if Assigned(FItems) then
      for I := Pred(FItems.Count) downto 0 do
        FItems[I].Restore;
  finally
    Owner.EnableChanges;
  end;
  RestoreChanged;
  Owner.NotifyRebuild;  // friend class
end;

{ TPressItemsMementoList }

function TPressItemsMementoList.Add(AObject: TPressItemsMemento): Integer;
begin
  Result := inherited Add(AObject);
end;

function TPressItemsMementoList.CreateIterator: TPressItemsMementoIterator;
begin
  Result := TPressItemsMementoIterator.Create(Self);
end;

function TPressItemsMementoList.Extract(
  AObject: TPressItemsMemento): TPressItemsMemento;
begin
  Result := inherited Extract(AObject) as TPressItemsMemento;
end;

function TPressItemsMementoList.GetItems(
  AIndex: Integer): TPressItemsMemento;
begin
  Result := inherited Items[AIndex] as TPressItemsMemento;
end;

function TPressItemsMementoList.IndexOf(
  AObject: TPressItemsMemento): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TPressItemsMementoList.Insert(
  Index: Integer; AObject: TPressItemsMemento);
begin
  inherited Insert(Index, AObject);
end;

function TPressItemsMementoList.InternalCreateIterator: TPressCustomIterator;
begin
  Result := CreateIterator;
end;

function TPressItemsMementoList.Remove(
  AObject: TPressItemsMemento): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TPressItemsMementoList.SetItems(
  AIndex: Integer; Value: TPressItemsMemento);
begin
  inherited Items[AIndex] := Value;
end;

{ TPressItemsMementoIterator }

function TPressItemsMementoIterator.GetCurrentItem: TPressItemsMemento;
begin
  Result := inherited CurrentItem as TPressItemsMemento;
end;

{ TPressValue }

function TPressValue.GetSignature: string;

  function FormatOwnerName: string;
  begin
    if Assigned(Owner) then
      Result := Owner.ClassName
    else
      Result := TPressObject.ClassName;
  end;

  function FormatValue: string;
  begin
    Result := AsString;
    if Length(Result) > 32 then
    begin
      SetLength(Result, 32);
      FillChar(Result[30], 3, '.');
    end;
  end;

begin
  Result := Format('%s(%s): %s', [FormatOwnerName, Name, FormatValue]);
end;

function TPressValue.InternalCreateMemento: TPressAttributeMemento;
begin
  Result := TPressValueMemento.Create(Self);
end;

{ TPressString }

procedure TPressString.Assign(Source: TPersistent);
begin
  if Source is TPressString then
    Value := TPressString(Source).Value
  else
    inherited;
end;

class function TPressString.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attString;
end;

class function TPressString.AttributeName: string;
begin
  Result := 'String';
end;

function TPressString.GetAsBoolean: Boolean;
begin
  if SameText(Value, SPressTrueString) then
    Result := True
  else if SameText(Value, SPressFalseString) then
    Result := False
  else
    raise ConversionError(nil);
end;

function TPressString.GetAsDate: TDate;
begin
  try
    Result := StrToDate(Value);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

function TPressString.GetAsDateTime: TDateTime;
begin
  try
    Result := StrToDateTime(Value);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

function TPressString.GetAsFloat: Double;
begin
  try
    Result := StrToFloat(Value);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

function TPressString.GetAsInteger: Integer;
begin
  try
    Result := StrToInt(Value);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

function TPressString.GetAsString: string;
begin
  Result := Value;
end;

function TPressString.GetAsTime: TTime;
begin
  try
    Result := StrToTime(Value);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

function TPressString.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressString.GetIsEmpty: Boolean;
begin
  Result := Value = '';
end;

function TPressString.GetValue: string;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressString.Reset;
begin
  FValue := '';
  IsChanged := True;
end;

procedure TPressString.SetAsBoolean(AValue: Boolean);
begin
  if AValue then
    Value := SPressTrueString
  else
    Value := SPressFalseString;
end;

procedure TPressString.SetAsDate(AValue: TDate);
begin
  Value := DateToStr(AValue);
end;

procedure TPressString.SetAsDateTime(AValue: TDateTime);
begin
  Value := DateTimeToStr(AValue);
end;

procedure TPressString.SetAsFloat(AValue: Double);
begin
  Value := FloatToStr(AValue);
end;

procedure TPressString.SetAsInteger(AValue: Integer);
begin
  Value := IntToStr(AValue);
end;

procedure TPressString.SetAsString(const AValue: string);
begin
  Value := AValue;
end;

procedure TPressString.SetAsTime(AValue: TTime);
begin
  Value := TimeToStr(AValue);
end;

procedure TPressString.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressString.SetValue(const AValue: string);
var
  VMaxSize: Integer;
  VOwnerName: string;
begin
  if IsNull or (FValue <> AValue) then
  begin
    if Assigned(Metadata) then
      VMaxSize := Metadata.Size
    else
      VMaxSize := 0;
    if (VMaxSize > 0) and (Length(AValue) > VMaxSize) then
    begin
      if Assigned(Owner) then
        VOwnerName := Owner.ClassName
      else
        VOwnerName := ClassName;
      raise EPressError.CreateFmt(SStringOverflow, [VOwnerName, Name]);
    end;
    Changing;
    FValue := AValue;
    Changed;
  end;
end;

{ TPressNumeric }

function TPressNumeric.GetAsBoolean: Boolean;
begin
  Result := AsInteger <> 0;
end;

function TPressNumeric.GetAsDate: TDate;
begin
  Result := Int(AsFloat);
end;

function TPressNumeric.GetAsDateTime: TDateTime;
begin
  Result := AsFloat;
end;

function TPressNumeric.GetAsTime: TTime;
begin
  Result := Frac(AsFloat);
end;

function TPressNumeric.GetDisplayText: string;
begin
  if IsNull then
    Result := ''
  else if EditMask <> '' then
    Result := FormatFloat(EditMask, AsFloat)
  else
    Result := AsString;
end;

procedure TPressNumeric.SetAsBoolean(AValue: Boolean);
begin
  AsInteger := Integer(AValue);
end;

procedure TPressNumeric.SetAsDate(AValue: TDate);
begin
  AsFloat := Int(AValue);
end;

procedure TPressNumeric.SetAsDateTime(AValue: TDateTime);
begin
  AsFloat := AValue;
end;

procedure TPressNumeric.SetAsTime(AValue: TTime);
begin
  AsFloat := Frac(AValue);
end;

{ TPressInteger }

procedure TPressInteger.Assign(Source: TPersistent);
begin
  if Source is TPressInteger then
    Value := TPressInteger(Source).Value
  else
    inherited;
end;

class function TPressInteger.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attInteger;
end;

class function TPressInteger.AttributeName: string;
begin
  Result := 'Integer';
end;

function TPressInteger.GetAsFloat: Double;
begin
  Result := Value;
end;

function TPressInteger.GetAsInteger: Integer;
begin
  Result := Value;
end;

function TPressInteger.GetAsString: string;
begin
  if IsNull then
    Result := ''
  else
    Result := IntToStr(Value);
end;

function TPressInteger.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressInteger.GetIsEmpty: Boolean;
begin
  Result := Value = 0;
end;

function TPressInteger.GetValue: Integer;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressInteger.Reset;
begin
  FValue := 0;
  IsChanged := True;
end;

procedure TPressInteger.SetAsFloat(AValue: Double);
begin
  Value := Round(AValue);
end;

procedure TPressInteger.SetAsInteger(AValue: Integer);
begin
  Value := AValue;
end;

procedure TPressInteger.SetAsString(const AValue: string);
begin
  try
    if AValue = '' then
      Clear
    else
      Value := StrToInt(AValue);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

procedure TPressInteger.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressInteger.SetValue(AValue: Integer);
begin
  if IsNull or (AValue <> FValue) then
  begin
    Changing;
    FValue := AValue;
    Changed;
  end;
end;

{ TPressFloat }

procedure TPressFloat.Assign(Source: TPersistent);
begin
  if Source is TPressFloat then
    Value := TPressFloat(Source).Value
  else
    inherited;
end;

class function TPressFloat.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attFloat;
end;

class function TPressFloat.AttributeName: string;
begin
  Result := 'Float';
end;

function TPressFloat.GetAsFloat: Double;
begin
  Result := Value;
end;

function TPressFloat.GetAsInteger: Integer;
begin
  Result := Round(Value);
end;

function TPressFloat.GetAsString: string;
begin
  if IsNull then
    Result := ''
  else
    Result := FloatToStr(Value);
end;

function TPressFloat.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressFloat.GetIsEmpty: Boolean;
begin
  Result := Value = 0;
end;

function TPressFloat.GetValue: Double;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressFloat.Reset;
begin
  FValue := 0;
  IsChanged := True;
end;

procedure TPressFloat.SetAsFloat(AValue: Double);
begin
  Value := AValue;
end;

procedure TPressFloat.SetAsInteger(AValue: Integer);
begin
  Value := AValue;
end;

procedure TPressFloat.SetAsString(const AValue: string);
begin
  try
    if AValue = '' then
      Clear
    else
      Value := StrToFloat(AValue)
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

procedure TPressFloat.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressFloat.SetValue(AValue: Double);
begin
  if IsNull or (AValue <> FValue) then
  begin
    Changing;
    FValue := AValue;
    Changed;
  end;
end;

{ TPressCurrency }

procedure TPressCurrency.Assign(Source: TPersistent);
begin
  if Source is TPressCurrency then
    Value := TPressCurrency(Source).Value
  else
    inherited;
end;

class function TPressCurrency.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attCurrency;
end;

class function TPressCurrency.AttributeName: string;
begin
  Result := 'Currency';
end;

function TPressCurrency.GetAsCurrency: Currency;
begin
  Result := Value;
end;

function TPressCurrency.GetAsFloat: Double;
begin
  Result := Value;
end;

function TPressCurrency.GetAsInteger: Integer;
begin
  Result := Round(Value);
end;

function TPressCurrency.GetAsString: string;
begin
  if IsNull then
    Result := ''
  else
    Result := CurrToStr(Value);
end;

function TPressCurrency.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressCurrency.GetDisplayText: string;
begin
  if IsNull then
    Result := ''
  else if EditMask <> '' then
    Result := FormatCurr(EditMask, Value)
  else
    Result := FormatCurr(',0.00', Value)
end;

function TPressCurrency.GetIsEmpty: Boolean;
begin
  Result := Value = 0;
end;

function TPressCurrency.GetValue: Currency;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressCurrency.Reset;
begin
  FValue := 0;
  IsChanged := True;
end;

procedure TPressCurrency.SetAsCurrency(AValue: Currency);
begin
  Value := AValue;
end;

procedure TPressCurrency.SetAsFloat(AValue: Double);
begin
  Value := AValue;
end;

procedure TPressCurrency.SetAsInteger(AValue: Integer);
begin
  Value := AValue;
end;

procedure TPressCurrency.SetAsString(const AValue: string);
begin
  try
    if AValue = '' then
      Clear
    else
      Value := StrToCurr(AValue)
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

procedure TPressCurrency.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressCurrency.SetValue(AValue: Currency);
begin
  if IsNull or (AValue <> FValue) then
  begin
    Changing;
    FValue := AValue;
    Changed;
  end;
end;

{ TPressEnum }

procedure TPressEnum.Assign(Source: TPersistent);
begin
  if Source is TPressEnum then
    if TPressEnum(Source).IsNull then
      Clear
    else
      Value := TPressEnum(Source).Value
  else
    inherited;
end;

class function TPressEnum.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attEnum;
end;

class function TPressEnum.AttributeName: string;
begin
  Result := 'Enum';
end;

function TPressEnum.GetAsBoolean: Boolean;
begin
  Result := IsNull;
end;

function TPressEnum.GetAsDate: TDate;
begin
  Result := Value;
end;

function TPressEnum.GetAsDateTime: TDateTime;
begin
  Result := Value;
end;

function TPressEnum.GetAsFloat: Double;
begin
  Result := Value;
end;

function TPressEnum.GetAsInteger: Integer;
begin
  Result := Value;
end;

function TPressEnum.GetAsString: string;
begin
  if IsNull then
    Result := ''
  else
    Result := Metadata.EnumMetadata.Items[Value];
end;

function TPressEnum.GetAsTime: TTime;
begin
  Result := 0;
end;

function TPressEnum.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressEnum.GetIsEmpty: Boolean;
begin
  Result := IsNull;
end;

function TPressEnum.GetValue: Integer;
begin
  VerifyCalcAttribute;
  if (FValue < 0) or
   (Assigned(Metadata) and (FValue >= Metadata.EnumMetadata.Items.Count)) then
    raise EPressError.CreateFmt(SEnumOutOfBounds, [Name, FValue]);
  Result := FValue;
end;

procedure TPressEnum.Reset;
begin
  FValue := -1;
  IsChanged := True;
end;

procedure TPressEnum.SetAsBoolean(AValue: Boolean);
begin
  Value := Ord(AValue);
end;

procedure TPressEnum.SetAsDate(AValue: TDate);
begin
  Value := Trunc(AValue);
end;

procedure TPressEnum.SetAsDateTime(AValue: TDateTime);
begin
  Value := Trunc(AValue);
end;

procedure TPressEnum.SetAsFloat(AValue: Double);
begin
  Value := Round(AValue);
end;

procedure TPressEnum.SetAsInteger(AValue: Integer);
begin
  Value := AValue;
end;

procedure TPressEnum.SetAsString(const AValue: string);
var
  VIndex: Integer;
begin
  if AValue = '' then
    Clear
  else
  begin
    VIndex := Metadata.EnumMetadata.Items.IndexOf(AValue);
    if VIndex <> -1 then
      Value := VIndex
    else
      raise EPressError.CreateFmt(SEnumItemNotFound, [AValue]);
  end;
end;

procedure TPressEnum.SetAsTime(AValue: TTime);
begin
  Value := 0;
end;

procedure TPressEnum.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressEnum.SetValue(AValue: Integer);
begin
  if AValue = -1 then
    Clear
  else if IsNull or (AValue <> FValue) then
  begin
    Changing;
    FValue := AValue;
    Changed;
  end;
end;

{ TPressBoolean }

procedure TPressBoolean.Assign(Source: TPersistent);
begin
  if Source is TPressBoolean then
    Value := TPressBoolean(Source).Value
  else
    inherited;
end;

class function TPressBoolean.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attBoolean;
end;

class function TPressBoolean.AttributeName: string;
begin
  Result := 'Boolean';
end;

function TPressBoolean.GetAsBoolean: Boolean;
begin
  Result := Value;
end;

function TPressBoolean.GetAsFloat: Double;
begin
  Result := AsInteger;
end;

function TPressBoolean.GetAsInteger: Integer;
begin
  Result := Integer(Value);
end;

function TPressBoolean.GetAsString: string;
begin
  if IsNull then
    Result := ''
  else
    Result := FValues[FValue];
end;

function TPressBoolean.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressBoolean.GetDisplayText: string;
begin
  Result := AsString;
end;

function TPressBoolean.GetValue: Boolean;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressBoolean.Initialize;
var
  VEditMask: string;
  VPos: Integer;
begin
  VEditMask := EditMask;
  if VEditMask = '' then
  begin
    FValues[False] := SPressFalseString;
    FValues[True] := SPressTrueString;
  end else
  begin
    VPos := Pos(';', VEditMask);
    if VPos = 0 then
      VPos := Length(VEditMask) + 1;
    FValues[False] := Copy(VEditMask, VPos + 1, Length(VEditMask));
    FValues[True] := Copy(VEditMask, 1, VPos - 1);
  end;
  inherited;
  if IsNull then
    Value := False;
end;

procedure TPressBoolean.Reset;
begin
  FValue := False;
  IsChanged := True;
end;

procedure TPressBoolean.SetAsBoolean(AValue: Boolean);
begin
  Value := AValue;
end;

procedure TPressBoolean.SetAsFloat(AValue: Double);
begin
  AsInteger := Round(AValue);
end;

procedure TPressBoolean.SetAsInteger(AValue: Integer);
begin
  Value := Boolean(AValue);
end;

procedure TPressBoolean.SetAsString(const AValue: string);
begin
  if AValue = '' then
    Clear
  else if SameText(AValue, SPressTrueString) then
    Value := True
  else if SameText(AValue, SPressFalseString) then
    Value := False
  else
    raise ConversionError(nil);
end;

procedure TPressBoolean.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressBoolean.SetValue(AValue: Boolean);
begin
  if IsNull or (AValue <> FValue) then
  begin
    Changing;
    FValue := AValue;
    Changed;
  end;
end;

{ TPressDate }

procedure TPressDate.Assign(Source: TPersistent);
begin
  if Source is TPressDate then
    Value := TPressDate(Source).Value
  else
    inherited;
end;

class function TPressDate.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attDate;
end;

class function TPressDate.AttributeName: string;
begin
  Result := 'Date';
end;

function TPressDate.GetAsDate: TDate;
begin
  Result := Value;
end;

function TPressDate.GetAsDateTime: TDateTime;
begin
  Result := Value;
end;

function TPressDate.GetAsFloat: Double;
begin
  Result := Value;
end;

function TPressDate.GetAsString: string;
begin
  if IsNull or (Value = 0) then
    Result := ''
  else
    Result := DateToStr(Value);
end;

function TPressDate.GetAsTime: TTime;
begin
  Result := 0;
end;

function TPressDate.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressDate.GetDisplayText: string;
begin
  if IsNull or (Value = 0) then
    Result := ''
  else if EditMask <> '' then
    Result := FormatDateTime(EditMask, Value)
  else
    Result := AsString;
end;

function TPressDate.GetValue: TDate;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressDate.Initialize;
begin
  if SameText(DefaultValue, 'now') then
    FValue := Date
  else
    inherited;
end;

procedure TPressDate.Reset;
begin
  FValue := 0;
  IsChanged := True;
end;

procedure TPressDate.SetAsDate(AValue: TDate);
begin
  Value := AValue;
end;

procedure TPressDate.SetAsDateTime(AValue: TDateTime);
begin
  Value := AValue;
end;

procedure TPressDate.SetAsFloat(AValue: Double);
begin
  Value := AValue;
end;

procedure TPressDate.SetAsString(const AValue: string);
begin
  try
    if AValue = '' then
      Clear
    else
      Value := StrToDate(AValue);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

procedure TPressDate.SetAsTime(AValue: TTime);
begin
  Value := 0;
end;

procedure TPressDate.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressDate.SetValue(AValue: TDate);
begin
  if IsNull or (FValue <> AValue) then
  begin
    Changing;
    if AValue = 0 then
      Clear
    else
    begin
      FValue := Int(AValue);
      Changed;
    end;
  end;
end;

{ TPressTime }

procedure TPressTime.Assign(Source: TPersistent);
begin
  if Source is TPressTime then
    Value := TPressTime(Source).Value
  else
    inherited;
end;

class function TPressTime.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attTime;
end;

class function TPressTime.AttributeName: string;
begin
  Result := 'Time';
end;

function TPressTime.GetAsDate: TDate;
begin
  Result := 0;
end;

function TPressTime.GetAsDateTime: TDateTime;
begin
  Result := Value;
end;

function TPressTime.GetAsFloat: Double;
begin
  Result := Value;
end;

function TPressTime.GetAsString: string;
begin
  if IsNull then
    Result := ''
  else
    Result := TimeToStr(Value);
end;

function TPressTime.GetAsTime: TTime;
begin
  Result := Value;
end;

function TPressTime.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressTime.GetDisplayText: string;
begin
  if IsNull then
    Result := ''
  else if EditMask <> '' then
    Result := FormatDateTime(EditMask, Value)
  else
    Result := AsString;
end;

function TPressTime.GetValue: TTime;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressTime.Initialize;
begin
  if SameText(DefaultValue, 'now') then
    FValue := Time
  else
    inherited;
end;

procedure TPressTime.Reset;
begin
  FValue := 0;
  IsChanged := True;
end;

procedure TPressTime.SetAsDate(AValue: TDate);
begin
  Value := 0;
end;

procedure TPressTime.SetAsDateTime(AValue: TDateTime);
begin
  Value := AValue;
end;

procedure TPressTime.SetAsFloat(AValue: Double);
begin
  Value := Value;
end;

procedure TPressTime.SetAsString(const AValue: string);
begin
  try
    if AValue = '' then
      Clear
    else
      Value := StrToTime(AValue);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

procedure TPressTime.SetAsTime(AValue: TTime);
begin
  Value := AValue;
end;

procedure TPressTime.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressTime.SetValue(AValue: TTime);
begin
  if IsNull or (FValue <> AValue) then
  begin
    Changing;
    FValue := Frac(AValue);
    Changed;
  end;
end;

{ TPressDateTime }

procedure TPressDateTime.Assign(Source: TPersistent);
begin
  if Source is TPressDateTime then
    Value := TPressDateTime(Source).Value
  else
    inherited;
end;

class function TPressDateTime.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attDateTime;
end;

class function TPressDateTime.AttributeName: string;
begin
  Result := 'DateTime';
end;

function TPressDateTime.GetAsDate: TDate;
begin
  Result := Int(Value);
end;

function TPressDateTime.GetAsDateTime: TDateTime;
begin
  Result := Value;
end;

function TPressDateTime.GetAsFloat: Double;
begin
  Result := Value;
end;

function TPressDateTime.GetAsString: string;
begin
  if Value = 0 then
    Result := ''
  else if Value < 1 then
    Result := TimeToStr(Value)
  else
    Result := DateTimeToStr(Value);
end;

function TPressDateTime.GetAsTime: TTime;
begin
  Result := Frac(Value);
end;

function TPressDateTime.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressDateTime.GetDisplayText: string;
begin
  if AsDateTime = 0 then
    Result := ''
  else if EditMask <> '' then
    Result := FormatDateTime(EditMask, Value)
  else
    Result := AsString;
end;

function TPressDateTime.GetValue: TDateTime;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressDateTime.Initialize;
begin
  if SameText(DefaultValue, 'now') then
    FValue := Now
  else
    inherited;
end;

procedure TPressDateTime.Reset;
begin
  FValue := 0;
  IsChanged := True;
end;

procedure TPressDateTime.SetAsDate(AValue: TDate);
begin
  Value := Int(AValue);
end;

procedure TPressDateTime.SetAsDateTime(AValue: TDateTime);
begin
  Value := AValue;
end;

procedure TPressDateTime.SetAsFloat(AValue: Double);
begin
  Value := AValue;
end;

procedure TPressDateTime.SetAsString(const AValue: string);
begin
  try
    if AValue = '' then
      Clear
    else
      Value := StrToDateTime(AValue);
  except
    on E: EConvertError do
      raise ConversionError(E);
    else
      raise;
  end;
end;

procedure TPressDateTime.SetAsTime(AValue: TTime);
begin
  Value := Frac(AValue);
end;

procedure TPressDateTime.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressDateTime.SetValue(AValue: TDateTime);
begin
  if IsNull or (FValue <> AValue) then
  begin
    Changing;
    if AValue = 0 then
      Clear
    else
    begin
      FValue := AValue;
      Changed;
    end;
  end;
end;

{ TPressVariant }

procedure TPressVariant.Assign(Source: TPersistent);
begin
  if Source is TPressVariant then
    Value := TPressVariant(Source).Value
  else
    inherited;
end;

class function TPressVariant.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attVariant;
end;

class function TPressVariant.AttributeName: string;
begin
  Result := 'Variant';
end;

function TPressVariant.GetAsBoolean: Boolean;
begin
  try
    Result := Value;
  except
    on E: EVariantError do
      raise InvalidValueError(Value, E);
    else
      raise;
  end;
end;

function TPressVariant.GetAsDate: TDate;
begin
  try
    Result := Value;
  except
    on E: EVariantError do
      raise InvalidValueError(Value, E);
    else
      raise;
  end;
end;

function TPressVariant.GetAsDateTime: TDateTime;
begin
  try
    Result := Value;
  except
    on E: EVariantError do
      raise InvalidValueError(Value, E);
    else
      raise;
  end;
end;

function TPressVariant.GetAsFloat: Double;
begin
  try
    Result := Value;
  except
    on E: EVariantError do
      raise InvalidValueError(Value, E);
    else
      raise;
  end;
end;

function TPressVariant.GetAsInteger: Integer;
begin
  try
    Result := Value;
  except
    on E: EVariantError do
      raise InvalidValueError(Value, E);
    else
      raise;
  end;
end;

function TPressVariant.GetAsString: string;
begin
  try
    if IsNull then
      Result := ''
    else
      Result := Value;
  except
    on E: EVariantError do
      raise InvalidValueError(Value, E);
    else
      raise;
  end;
end;

function TPressVariant.GetAsTime: TTime;
begin
  try
    Result := Value;
  except
    on E: EVariantError do
      raise InvalidValueError(Value, E);
    else
      raise;
  end;
end;

function TPressVariant.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressVariant.GetValue: Variant;
begin
  VerifyCalcAttribute;
  Result := FValue;
end;

procedure TPressVariant.Reset;
begin
  FValue := Null;
  IsChanged := True;
end;

procedure TPressVariant.SetAsBoolean(AValue: Boolean);
begin
  Value := AValue;
end;

procedure TPressVariant.SetAsDate(AValue: TDate);
begin
  Value := AValue;
end;

procedure TPressVariant.SetAsDateTime(AValue: TDateTime);
begin
  Value := AValue;
end;

procedure TPressVariant.SetAsFloat(AValue: Double);
begin
  Value := AValue;
end;

procedure TPressVariant.SetAsInteger(AValue: Integer);
begin
  Value := AValue;
end;

procedure TPressVariant.SetAsString(const AValue: string);
begin
  Value := AValue;
end;

procedure TPressVariant.SetAsTime(AValue: TTime);
begin
  Value := AValue;
end;

procedure TPressVariant.SetAsVariant(AValue: Variant);
begin
  Value := AValue;
end;

procedure TPressVariant.SetValue(AValue: Variant);
begin
  if IsNull or (FValue <> AValue) then
  begin
    Changing;
    if AValue = Null then
      Clear
    else
    begin
      FValue := AValue;
      Changed;
    end;
  end;
end;

{ TPressBlob }

procedure TPressBlob.Assign(Source: TPersistent);
begin
  if Source is TPressBlob then
    LoadFromStream(TPressBlob(Source).FStream)
  else
    inherited;
end;

procedure TPressBlob.ClearBuffer;
begin
  if Assigned(FStream) and (FStream.Size > 0) then
  begin
    Changing;
    FStream.Clear;
    IsChanged := True;
  end;
end;

procedure TPressBlob.Finit;
begin
  FStream.Free;
  inherited;
end;

function TPressBlob.GetAsString: string;
begin
  Result := Value;
end;

function TPressBlob.GetAsVariant: Variant;
begin
  Result := Value;
end;

function TPressBlob.GetSize: Integer;
begin
  if Assigned(FStream) then
    Result := FStream.Size
  else
    Result := 0;
end;

function TPressBlob.GetStream: TMemoryStream;
begin
  if not Assigned(FStream) then
    FStream := TMemoryStream.Create;
  Result := FStream;
end;

function TPressBlob.GetValue: string;
begin
  VerifyCalcAttribute;
  if Assigned(FStream) and (FStream.Size > 0) then
  begin
    SetLength(Result, FStream.Size);
    FStream.Position := 0;
    FStream.Read(Result[1], FStream.Size);
  end else
    Result := '';
end;

procedure TPressBlob.LoadFromStream(AStream: TStream);
begin
  if Assigned(AStream) then
  begin
    Changing;
    Stream.LoadFromStream(AStream);
    Changed;
  end;
end;

procedure TPressBlob.Reset;
begin
  ClearBuffer;
end;

procedure TPressBlob.SaveToStream(AStream: TStream);
begin
  VerifyCalcAttribute;
  if Assigned(AStream) then
    Stream.SaveToStream(AStream);
end;

procedure TPressBlob.SetAsString(const AValue: string);
begin
  Value := AValue;
end;

procedure TPressBlob.SetAsVariant(AValue: Variant);
begin
  try
    Value := AValue;
  except
    on E: EVariantError do
      raise InvalidValueError(AValue, E);
    else
      raise;
  end;
end;

procedure TPressBlob.SetValue(const AValue: string);
begin
  if Length(AValue) > 0 then
    WriteBuffer(AValue[1], Length(AValue))
  else if IsNull then
  begin
    Changing;
    Changed;
  end else
    ClearBuffer;
end;

function TPressBlob.WriteBuffer(const ABuffer; ACount: Integer): Boolean;

  function ChangedValue: Boolean;
  var
    Ch: Char;
    I: Integer;
  begin
    Result := Stream.Size <> ACount;
    if Result then
      Exit;
    Stream.Position := 0;
    for I := 0 to Pred(ACount) do
    begin
      Result := (Stream.Read(Ch, 1) = 0) or (PChar(@ABuffer)[I] <> Ch);
      if Result then
        Exit;
    end;
  end;

begin
  Result := ChangedValue;
  if Result then
  begin
    Changing;
    if ACount > 0 then
    begin
      Stream.Position := 0;
      Stream.Size := ACount;
      Stream.WriteBuffer(ABuffer, ACount);
    end else
      Stream.Clear;
    Changed;
  end;
end;

{ TPressMemo }

class function TPressMemo.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attMemo;
end;

class function TPressMemo.AttributeName: string;
begin
  Result := 'Memo';
end;

{ TPressBinary }

class function TPressBinary.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attBinary;
end;

class function TPressBinary.AttributeName: string;
begin
  Result := 'Binary';
end;

{ TPressPicture }

procedure TPressPicture.AssignPicture(APicture: TPicture);
begin
  { TODO : Implement }
end;

procedure TPressPicture.AssignPictureFromFile(const AFileName: string);
var
  VPicture: TPicture;
begin
  VPicture := TPicture.Create;
  try
    VPicture.LoadFromFile(AFileName);
    AssignPicture(VPicture);
  finally
    VPicture.Free;
  end;
end;

class function TPressPicture.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attPicture;
end;

class function TPressPicture.AttributeName: string;
begin
  Result := 'Picture';
end;

procedure TPressPicture.ClearPicture;
begin
  { TODO : Implement }
end;

function TPressPicture.GetHasPicture: Boolean;
begin
  { TODO : Implement }
  Result := False;
end;

{ TPressItem }

procedure TPressItem.Assign(Source: TPersistent);
begin
  if Source is TPressItem then
    InternalAssignItem(TPressItem(Source).Proxy)
  else
    inherited;
end;

procedure TPressItem.AssignReference(const AClassName, AId: string);
begin
  Proxy.AssignReference(AClassName, AId);
end;

procedure TPressItem.Finit;
begin
  FProxy.Free;
  inherited;
end;

function TPressItem.GetIsEmpty: Boolean;
begin
  Result := not Assigned(FProxy) or FProxy.IsEmpty; 
end;

function TPressItem.GetObjectClassName: string;
begin
  Result := Proxy.ObjectClassName;
end;

function TPressItem.GetObjectId: string;
begin
  Result := Proxy.ObjectId;
end;

function TPressItem.GetProxy: TPressProxy;
begin
  if not Assigned(FProxy) then
  begin
    FProxy := TPressProxy.Create(InternalProxyType);
    BindProxy(FProxy);
  end;
  Result := FProxy;
end;

function TPressItem.GetSignature: string;
begin
  if Assigned(FProxy) then
  begin
    if Proxy.HasInstance then
      Result := Proxy.Instance.Signature
    else if Proxy.HasReference then
      Result := Proxy.ObjectId
    else
      Result := SPressNilString;
  end else
    Result := SPressNilString;
end;

function TPressItem.GetValue: TPressObject;
begin
  Result := Proxy.Instance;
end;

function TPressItem.HasInstance: Boolean;
begin
  Result := Proxy.HasInstance;
end;

procedure TPressItem.InternalAssignObject(AObject: TPressObject);
begin
  Value := AObject;
end;

function TPressItem.InternalCreateMemento: TPressAttributeMemento;
begin
  Result := TPressItemMemento.Create(Self, Proxy);
end;

procedure TPressItem.InternalUnassignObject(AObject: TPressObject);
begin
  if Proxy.SameReference(AObject) then
    Proxy.ClearInstance;
end;

procedure TPressItem.Reset;
begin
  if Assigned(FProxy) then
    FProxy.Instance := nil;
end;

function TPressItem.SameReference(AObject: TPressObject): Boolean;
begin
  Result := (not Assigned(AObject) and not Assigned(FProxy)) or
   (Assigned(FProxy) and FProxy.SameReference(AObject));
end;

function TPressItem.SameReference(const ARefClass, ARefID: string): Boolean;
begin
  Result := Proxy.SameReference(ARefClass, ARefID);
end;

procedure TPressItem.SetValue(AValue: TPressObject);
begin
  Proxy.Instance := AValue;
end;

{ TPressPart }

procedure TPressPart.AfterChangeItem(AItem: TPressObject);
begin
  inherited;
  Changed;
end;

class function TPressPart.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attPart;
end;

class function TPressPart.AttributeName: string;
begin
  Result := 'Part';
end;

procedure TPressPart.BeforeChangeInstance(
  Sender: TPressProxy; Instance: TPressObject;
  ChangeType: TPressProxyChangeType);
begin
  inherited;

end;

procedure TPressPart.BeforeChangeItem(AItem: TPressObject);
begin
  inherited;
  Changing;
end;

procedure TPressPart.BeforeRetrieveInstance(Sender: TPressProxy);
begin
  if Sender.IsEmpty then
  begin
    DisableChanges;
    try
      Sender.Instance := ObjectClass.Create;
    finally
      EnableChanges;
    end;
  end;
  inherited;
end;

procedure TPressPart.BindInstance(AInstance: TPressObject);
begin
  inherited;
  TPressObjectFriend(AInstance).SetOwnerContext(Self);
end;

procedure TPressPart.InternalAssignItem(AProxy: TPressProxy);
begin
  Value := AProxy.Instance.Clone;
end;

function TPressPart.InternalProxyType: TPressProxyType;
begin
  Result := ptOwned;
end;

procedure TPressPart.ReleaseInstance(AInstance: TPressObject);
begin
  inherited;
  TPressObjectFriend(AInstance).ClearOwnerContext;
end;

{ TPressReference }

procedure TPressReference.AfterChangeItem(AItem: TPressObject);
begin
  inherited;
  NotifyReferenceChange;
end;

class function TPressReference.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attReference;
end;

class function TPressReference.AttributeName: string;
begin
  Result := 'Reference';
end;

procedure TPressReference.InternalAssignItem(AProxy: TPressProxy);
begin
  Value := AProxy.Instance;
end;

function TPressReference.InternalProxyType: TPressProxyType;
begin
  Result := ptShared;
end;

{ TPressItemsChangedEvent }

constructor TPressItemsChangedEvent.Create(
  AOwner: TObject; AProxy: TPressProxy;
  AIndex: Integer; AEventType: TPressItemsEventType);
begin
  inherited Create(AOwner);
  FEventType := AEventType;
  FIndex := AIndex;
  FProxy := AProxy;
end;

{ TPressItems }

function TPressItems.Add(AObject: TPressObject): Integer;
begin
  Result := ProxyList.AddInstance(AObject);
end;

function TPressItems.AddReference(const AClassName, AId: string): Integer;
begin
  Result := ProxyList.AddReference(AClassName, AId);
end;

procedure TPressItems.AfterChangeInstance(
  Sender: TPressProxy; Instance: TPressObject;
  ChangeType: TPressProxyChangeType);
begin
  inherited;
  { TODO : Verify this improvement }
  //ChangedItem(Instance, ChangeType = pctAssigning);
  if ChangeType = pctAssigning then
    ChangedItem(Instance, True);
end;

procedure TPressItems.Assign(Source: TPersistent);
begin
  if Source is TPressItems then
  begin
    DisableChanges;
    try
      if Assigned(FProxyList) then
        FProxyList.Clear;
      with TPressItems(Source).CreateProxyIterator do
      try
        BeforeFirstItem;
        while NextItem do
          InternalAssignItem(CurrentItem);
      finally
        Free;
      end;
    finally
      EnableChanges;
    end;
    NotifyRebuild;
  end else
    inherited;
end;

procedure TPressItems.AssignProxyList(AProxyList: TPressProxyList);
begin
  Clear;
  FProxyList.Free;
  FProxyList := AProxyList;
  if Assigned(FProxyList) then
  begin
    FProxyList.OnChangeList := ChangedList;
    with FProxyList.CreateIterator do
    try
      BeforeFirstItem;
      while NextItem do
      begin
        ValidateProxy(CurrentItem);
        BindProxy(CurrentItem);
      end;
    finally
      Free;
    end;
    NotifyRebuild;
  end;
end;

procedure TPressItems.ChangedItem(
  AItem: TPressObject; ASubjectChanged: Boolean);
var
  VIndex: Integer;
  VEventType: TPressItemsEventType;
begin
  if ChangesDisabled then
    Exit;
  VIndex := ProxyList.IndexOfInstance(AItem);
  if VIndex >= 0 then
  begin
    if ASubjectChanged then
      VEventType := ietModify
    else
      VEventType := ietNotify;
    TPressItemsChangedEvent.Create(
     Self, ProxyList[VIndex], VIndex, VEventType).Notify;
  end;
  if ASubjectChanged then
    Changed;
end;

procedure TPressItems.ChangedList(
  Sender: TPressProxyList; Item: TPressProxy; Action: TListNotification);

  procedure DoChanges;
  var
    VEventType: TPressItemsEventType;
    VIndex: Integer;
  begin
    Changing;
    case Action of
      lnAdded:
        begin
          ValidateProxy(Item);
          if Sender[Sender.Count - 1] = Item then
          begin
            VEventType := ietAdd;
            VIndex := Sender.Count - 1;
          end else
          begin
            VEventType := ietInsert;
            VIndex := Sender.IndexOf(Item);
          end;
          BindProxy(Item);
          NotifyMementos(Item, isAdded);
        end;
      else {lnExtracted, lnDeleted}
        begin
          if Item.HasInstance then
            ReleaseInstance(Item.Instance);
          VEventType := ietRemove;
          VIndex := -1;
          { TODO : OldIndex? }
          NotifyMementos(Item, isDeleted, -1);
        end;
    end;
    TPressItemsChangedEvent.Create(Self, Item, VIndex, VEventType).Notify;
    Changed;
  end;

  procedure UpdateInstance;
  begin
    if Action = lnAdded then
    begin
      ValidateProxy(Item);
      BindProxy(Item);
    end else {lnExtracted, lnDeleted}
      if Item.HasInstance then
        ReleaseInstance(Item.Instance);
  end;

begin
  if ChangesDisabled then
    UpdateInstance
  else
    DoChanges;
end;

procedure TPressItems.Clear;
begin
  if Assigned(FProxyList) then
  begin
    DisableChanges;
    try
      FProxyList.Clear;
    finally
      EnableChanges;
    end;
    TPressItemsChangedEvent.Create(Self, nil, -1, ietClear).Notify;
  end;
end;

function TPressItems.Count: Integer;
begin
  if Assigned(FProxyList) then
    Result := FProxyList.Count
  else
    Result := 0;
end;

function TPressItems.CreateIterator: TPressItemsIterator;
begin
  Result := InternalCreateIterator;
end;

function TPressItems.CreateProxyIterator: TPressProxyIterator;
begin
  Result := TPressProxyIterator.Create(ProxyList);
end;

procedure TPressItems.Delete(AIndex: Integer);
begin
  ProxyList.Delete(AIndex);
end;

procedure TPressItems.Finit;
begin
  Clear;
  FProxyList.Free;
  FMementos.Free;
  inherited;
end;

function TPressItems.GetHasAddedItem: Boolean;
begin
  { TODO : Implement }
  Result := False;
end;

function TPressItems.GetHasDeletedItem: Boolean;
begin
  Result := Assigned(FProxyDeletedList) and (FProxyDeletedList.Count > 0);
end;

function TPressItems.GetIsEmpty: Boolean;
begin
  Result := Count = 0;
end;

function TPressItems.GetMementos: TPressItemsMementoList;
begin
  if not Assigned(FMementos) then
    FMementos := TPressItemsMementoList.Create(False);
  Result := FMementos;
end;

function TPressItems.GetObjects(AIndex: Integer): TPressObject;
begin
  Result := ProxyList[AIndex].Instance;
end;

function TPressItems.GetProxies(AIndex: Integer): TPressProxy;
begin
  Result := ProxyList[AIndex];
end;

function TPressItems.GetProxyDeletedList: TPressProxyList;
begin
  if not Assigned(FProxyDeletedList) then
    FProxyDeletedList := TPressProxyList.Create(True, InternalProxyType);
  Result := FProxyDeletedList;
end;

function TPressItems.GetProxyList: TPressProxyList;
begin
  if not Assigned(FProxyList) then
    AssignProxyList(TPressProxyList.Create(True, InternalProxyType));
  Result := FProxyList;
end;

function TPressItems.IndexOf(AObject: TPressObject): Integer;
begin
  Result := ProxyList.IndexOfInstance(AObject);
end;

procedure TPressItems.Insert(AIndex: Integer; AObject: TPressObject);
begin
  ProxyList.InsertInstance(AIndex, AObject);
end;

procedure TPressItems.InternalAssignObject(AObject: TPressObject);
begin
  Add(AObject);
end;

function TPressItems.InternalCreateIterator: TPressItemsIterator;
begin
  Result := TPressItemsIterator.Create(ProxyList);
end;

function TPressItems.InternalCreateMemento: TPressAttributeMemento;
begin
  Result := TPressItemsMemento.Create(Self);
  try
    Mementos.Add(TPressItemsMemento(Result));
  except
    Result.Free;
    raise;
  end;
end;

procedure TPressItems.InternalUnassignObject(AObject: TPressObject);
begin
  ProxyList.RemoveInstance(AObject);
end;

procedure TPressItems.NotifyMementos(
  AProxy: TPressProxy; AItemState: TPressItemState; AOldIndex: Integer);
begin
  if Assigned(FMementos) then
    with FMementos.CreateIterator do
    try
      BeforeFirstItem;
      while NextItem do
        CurrentItem.Notify(AProxy, AItemState, AOldIndex);
    finally
      Free;
    end;
end;

procedure TPressItems.NotifyRebuild;
begin
  TPressItemsChangedEvent.Create(Self, nil, -1, ietRebuild).Notify;
  if Assigned(Owner) then
    TPressObjectFriend(Owner).NotifyInvalidate;
end;

function TPressItems.Remove(AObject: TPressObject): Integer;
begin
  Result := ProxyList.IndexOfInstance(AObject);
  if Result >= 0 then
    Delete(Result);
end;

procedure TPressItems.SetObjects(AIndex: Integer; AValue: TPressObject);
begin
  ProxyList[AIndex].Instance := AValue;
end;

{ TPressItemsIterator }

function TPressItemsIterator.GetCurrentItem: TPressObject;
begin
  Result := inherited CurrentItem.Instance;
end;

{ TPressParts }

procedure TPressParts.AfterChangeItem(AItem: TPressObject);
begin
  inherited;
  ChangedItem(AItem);
end;

class function TPressParts.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attParts;
end;

class function TPressParts.AttributeName: string;
begin
  if Self = TPressParts then
    Result := 'Parts'
  else
    Result := ClassName;
end;

procedure TPressParts.BeforeChangeInstance(Sender: TPressProxy;
  Instance: TPressObject; ChangeType: TPressProxyChangeType);
begin
  inherited;
  if not ChangesDisabled and (ChangeType = pctAssigning) then
    NotifyMementos(Sender, isModified);
end;

procedure TPressParts.BeforeChangeItem(AItem: TPressObject);
var
  VIndex: Integer;
begin
  inherited;
  if ChangesDisabled then
    Exit;
  Changing;
  VIndex := ProxyList.IndexOfInstance(AItem);
  if VIndex >= 0 then
    NotifyMementos(ProxyList[VIndex], isModified);
end;

procedure TPressParts.BeforeRetrieveInstance(Sender: TPressProxy);
begin
  if Sender.IsEmpty then
  begin
    DisableChanges;
    try
      Sender.Instance := ObjectClass.Create;
    finally
      EnableChanges;
    end;
  end;
  inherited;
end;

procedure TPressParts.BindInstance(AInstance: TPressObject);
begin
  inherited;
  TPressObjectFriend(AInstance).SetOwnerContext(Self);
end;

procedure TPressParts.InternalAssignItem(AProxy: TPressProxy);
begin
  Add(AProxy.Instance.Clone);
end;

function TPressParts.InternalProxyType: TPressProxyType;
begin
  Result := ptOwned;
end;

procedure TPressParts.ReleaseInstance(AInstance: TPressObject);
begin
  inherited;
  TPressObjectFriend(AInstance).ClearOwnerContext;
end;

{ TPressReferences }

procedure TPressReferences.AfterChangeItem(AItem: TPressObject);
begin
  inherited;
  ChangedItem(AItem, False);
  NotifyReferenceChange;
end;

class function TPressReferences.AttributeBaseType: TPressAttributeBaseType;
begin
  Result := attReferences;
end;

class function TPressReferences.AttributeName: string;
begin
  if Self = TPressReferences then
    Result := 'References'
  else
    Result := ClassName;
end;

procedure TPressReferences.InternalAssignItem(AProxy: TPressProxy);
begin
  Add(AProxy.Instance);
end;

function TPressReferences.InternalProxyType: TPressProxyType;
begin
  Result := ptShared;
end;

{ Initialization routines }

procedure RegisterAttributes;
begin
  TPressString.RegisterAttribute;
  TPressInteger.RegisterAttribute;
  TPressFloat.RegisterAttribute;
  TPressCurrency.RegisterAttribute;
  TPressEnum.RegisterAttribute;
  TPressBoolean.RegisterAttribute;
  TPressDate.RegisterAttribute;
  TPressTime.RegisterAttribute;
  TPressDateTime.RegisterAttribute;
  TPressVariant.RegisterAttribute;
  TPressMemo.RegisterAttribute;
  TPressBinary.RegisterAttribute;
  TPressPicture.RegisterAttribute;
  TPressPart.RegisterAttribute;
  TPressReference.RegisterAttribute;
  TPressParts.RegisterAttribute;
  TPressReferences.RegisterAttribute;
end;

initialization
  RegisterAttributes;

end.
