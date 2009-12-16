//---------------------------------------------------------------------------
#ifndef OverbyteIcsUdpSend1H
#define OverbyteIcsUdpSend1H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "OverbyteIcsWSocket.hpp"
#include "OverbyteIcsWndControl.hpp"
//---------------------------------------------------------------------------
class TMainForm : public TForm
{
__published:	// IDE-managed Components
    TLabel *Label1;
    TButton *SendButton;
    TEdit *MessageEdit;
    TEdit *PortEdit;
    TWSocket *WSocket;
    void __fastcall FormShow(TObject *Sender);
    void __fastcall FormCloseQuery(TObject *Sender, bool &CanClose);
    void __fastcall SendButtonClick(TObject *Sender);
private:	// User declarations
    AnsiString FIniFileName;
    AnsiString FSectionName;
    AnsiString FKeyName;
public:		// User declarations
    __fastcall TMainForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TMainForm *MainForm;
//---------------------------------------------------------------------------
#endif
