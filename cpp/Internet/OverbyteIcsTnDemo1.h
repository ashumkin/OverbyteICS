//---------------------------------------------------------------------------
#ifndef OverbyteIcsTnDemo1H
#define OverbyteIcsTnDemo1H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\ExtCtrls.hpp>
#include "OverbyteIcsTnCnx.hpp"
#include "OverbyteIcsWndControl.hpp"
//---------------------------------------------------------------------------
class TTnDemoForm : public TForm
{
__published:	// IDE-managed Components
    TMemo *DisplayMemo;
    TPanel *Panel1;
    TLabel *HostLabel;
    TLabel *InfoLabel;
    TLabel *PortLabel;
    TEdit *HostEdit;
    TButton *ConnectButton;
    TButton *DisconnectButton;
    TEdit *PortEdit;
    TTnCnx *TnCnx;
    void __fastcall ConnectButtonClick(TObject *Sender);
    void __fastcall DisconnectButtonClick(TObject *Sender);
    
    void __fastcall TnCnxSessionConnected(TTnCnx *Sender, WORD Error);
    void __fastcall TnCnxSessionClosed(TTnCnx *Sender, WORD Error);
    void __fastcall TnCnxDataAvailableX(TTnCnx *Sender, PChar Buffer, int Len);
    void __fastcall DisplayMemoKeyDown(TObject *Sender, WORD &Key,
    TShiftState Shift);
    void __fastcall DisplayMemoKeyPress(TObject *Sender, wchar_t &Key);
        void __fastcall TnCnxDataAvailable(TTnCnx *Sender, Pointer Buffer,
          int Len);
private:	// User declarations
public:		// User declarations
    __fastcall TTnDemoForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TTnDemoForm *TnDemoForm;
//---------------------------------------------------------------------------
#endif
