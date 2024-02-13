public class GerarCotacaoController {
    public Cotacao__c currentQuotation { get; set; }
    public List<Produto__c> productList { get; set; }
    public GerarCotacaoController() {
        // Get Id 
        String cotacaoId = ApexPages.currentPage().getParameters().get('recordId');

  
        if (cotacaoId != null) {
            // recuperar dados da cotação__c
            currentQuotation = [SELECT Id, Name, Valor_Total__c, Nome_do_Cliente__r.Name FROM Cotacao__c WHERE Id = :cotacaoId LIMIT 1];

            // Recuperar dados produto__c
            if (currentQuotation != null) {
                productList = [
                    SELECT Id, Name, Desconto__c, Descricao__c, Margem_de_Lucro__c, Porcentagem_de_Imposto__c, 
                    Quantidade__c, Valor_Final__c, Valor_Unitario__c,Cotacao__r.Nome_do_Cliente__c,
                           Cotacao__r.Name, Cotacao__r.Valor_Total__c
                    FROM Produto__c 
                    WHERE Cotacao__c = :currentQuotation.Id
                ];
            } else {
                productList = new List<Produto__c>();
            }
        }
    }

    public List<Produto__c> getProductList() {
        return productList;
    }
}