import { LightningElement, api } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';


export default class SimularCotacao extends LightningElement {
    // Flexipage provides recordId and objectApiName
    @api recordId;
    @api objectApiName;

    loading = false;

    handleSubmit(event) {
        this.loading = true;
    }

    handleError() {
        this.loading = false;
    }

    handleSuccess(event) {
        this.loading = false;
        this.dispatchEvent(new RefreshEvent());
    }
}