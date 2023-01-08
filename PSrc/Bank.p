
type tWithdraw = (accountId: int, amount: int, clientId : int);

event eWithdraw : tWithdraw;
event checkBalance : tWithdraw;
event updateBalance : tWithdraw;
event handleRequest;
event repeat;

machine Bank {
    var balance: map[int, int];

    start state Init {
        entry (b: map[int, int]) {
            balance = b;
            send this, handleRequest;
        }
        on handleRequest do {
            goto HandleRequest;
        }
        defer eWithdraw;
        defer checkBalance;
        defer updateBalance;

    }

    state HandleRequest {
        entry {
            assert balance[0] >= 0, "Bank Overdraft when returing to Handle Request!";
        }
        on eWithdraw do (wReq : tWithdraw) {
            send this, checkBalance, wReq;
        }
        on checkBalance do (wReq : tWithdraw) {
            goto CheckBalance, wReq;
        }
        defer updateBalance;
        on handleRequest do {
            goto HandleRequest;
        }
    }

    state CheckBalance {
        entry (wReq : tWithdraw) {
            
            if (balance[wReq.accountId] - wReq.amount >= 0) {
                send this, updateBalance, wReq;
            } else {
                send this, handleRequest;
            }
        }

        on checkBalance do (wReq : tWithdraw) {
            goto CheckBalance, wReq;
        }
        on updateBalance do (wReq : tWithdraw) {
            goto MakeWithdraw, wReq;           
        }
        defer handleRequest;
        defer eWithdraw;
        
    }

    state MakeWithdraw {
        entry(wReq : tWithdraw) {
            
            balance[wReq.accountId] = balance[wReq.accountId] - wReq.amount; 
            assert balance[wReq.accountId] >= 0, "Bank Overdraft during withdraw!";
            goto HandleRequest;
        }
        defer eWithdraw;
        defer checkBalance;
        defer handleRequest;
    }
}