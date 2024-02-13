trigger updateValorTotal on Produto__c (after insert, after update, after delete) {
    Set<Id> cotacaoIds = new Set<Id>();
//verificar lista de produtos no insert e no update
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Produto__c produto : Trigger.new) {
           if (produto.Cotacao__c != null) {
                cotacaoIds.add(produto.Cotacao__c);
            }
        }
    }
//verificar no delete
    if (Trigger.isDelete) {
        for (Produto__c produto : Trigger.old) {
                cotacaoIds.add(produto.Cotacao__c);
        }
    }

    List<Cotacao__c> cotacoesToUpdate = new List<Cotacao__c>();
    // realizar soma do valor de todos os produtos
    for (Id cotacaoId : cotacaoIds) {
        Decimal totalValorFinal = 0;

        AggregateResult[] aggResults = [
            SELECT SUM(Valor_Final__c) 
            FROM Produto__c 
            WHERE Cotacao__c = :cotacaoId
        ];
//adicionar a lista se tiver mais de um resultado
        if (aggResults.size() > 0 && aggResults[0].get('expr0') != null) {
            totalValorFinal = (Decimal) aggResults[0].get('expr0');
        }

        cotacoesToUpdate.add(new Cotacao__c(Id = cotacaoId, Valor_Total__c = totalValorFinal));
    }
//fazer update
    if (!cotacoesToUpdate.isEmpty()) {
        update cotacoesToUpdate;
    }
}