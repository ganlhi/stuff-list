import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {NewViewComponent} from './new-view.component';
import {ListViewComponent} from './list-view.component';


const routes: Routes = [
  {path: '', pathMatch: 'full', redirectTo: '/list/all'},
  {path: 'list/:filter', component: ListViewComponent},
  {path: 'new', component: NewViewComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
