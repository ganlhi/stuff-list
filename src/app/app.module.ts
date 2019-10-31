import {FormsModule} from '@angular/forms';
import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';

import {AppRoutingModule} from './app-routing.module';
import {AppComponent} from './app.component';
import {ListViewComponent} from './list-view.component';
import {NewViewComponent} from './new-view.component';
import {SidebarComponent} from './sidebar.component';
import { ListItemComponent } from './list-item.component';

@NgModule({
  declarations: [
    AppComponent,
    ListViewComponent,
    NewViewComponent,
    SidebarComponent,
    ListItemComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
}
