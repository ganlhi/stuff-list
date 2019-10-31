import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  template: `
      <app-sidebar></app-sidebar>
      <section>
          <router-outlet></router-outlet>
      </section>
  `,
  styles: [`
      :host {
          height: 100vh;
          display: flex;
          align-items: stretch;
      }
      app-sidebar {
          width: 200px;
      }
      section {
          padding-top: 80px;
          flex: 1;
      }
  `]
})
export class AppComponent {

}
