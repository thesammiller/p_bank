machine Client {
    var accountId: int;
    var bank: Bank;
    var clientId : int;

    start state Init {
        entry(input: (accountId : int, bank: Bank, clientId : int)) {
            accountId = input.accountId;
            bank = input.bank;
            clientId = input.clientId;
            goto WithdrawMoney;
        }
    }

    state WithdrawMoney {
        entry {
            var a : int;
            a = getMoney();
            send bank, eWithdraw, (accountId = accountId, amount = a, clientId = clientId);
            send this, repeat;
        }
        on repeat do {
            goto WithdrawMoney;
        }
    }

    fun getMoney() : int {
        if ($) {
            return 1;
        }
        else {
            return 2;
        }
    }
}  