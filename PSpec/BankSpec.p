event NoOverdraftsInit : map[int, int];

spec NoOverdrafts observes eWithdraw, NoOverdraftsInit {
    var balance: map[int, int];

    start state Init { 
        entry  {
        }
        on NoOverdraftsInit goto WaitForWithDrawReqAndResp with (b: map[int, int]){
            balance = b;
        }
    }

    state WaitForWithDrawReqAndResp {
        entry {

        }

        on eWithdraw do (wReq : tWithdraw) {
            if (balance[wReq.accountId] - wReq.amount >= 0) {
                balance[wReq.accountId] = balance[wReq.accountId] - wReq.amount;
            } else {
                balance[wReq.accountId] = balance[wReq.accountId];
            }
            assert balance[wReq.accountId] >= 0, "Spec Overdraft!";
        }

        
        
    }

}