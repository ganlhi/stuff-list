import {Component} from '@angular/core';
import {Observable} from 'rxjs';
import {map} from 'rxjs/operators';
import {StuffService} from './stuff.service';

@Component({
  selector: 'app-sidebar',
  template: `
      <h1>Stuff List</h1>

      <nav>
          <ul>
              <li><a [routerLink]="['/list/all']">Complete list</a></li>
              <li><a [routerLink]="['/list/favorites']">Favorites ({{nbFavorites$ | async}})</a></li>
              <li><a [routerLink]="['/new']">Add stuff</a></li>
          </ul>
      </nav>
  `,
  styles: []
})
export class SidebarComponent {

  nbFavorites$: Observable<number> = this.stuffService.stuff$.pipe(
    map(list => list.filter(s => s.favorite).length),
  );

  constructor(private stuffService: StuffService) {
  }
}
