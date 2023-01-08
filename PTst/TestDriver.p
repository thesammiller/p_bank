

machine Test {
    start state Init {
        entry {
            var bankBalance: map[int, int];
            var server: Bank;
            var client1: Client;
            var client2: Client;

            bankBalance[0] = 3;

            announce NoOverdraftsInit, bankBalance;

            server = new Bank(bankBalance);
            client1 = new Client((accountId = 0, bank = server, clientId = 1));
            client2 = new Client((accountId = 0, bank = server, clientId = 2));

            


        }
    }
}