import {Component} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {combineLatest} from 'rxjs';
import {map} from 'rxjs/operators';
import {Stuff} from './stuff';
import {StuffService} from './stuff.service';

@Component({
  selector: 'app-list-view',
  template: `
    <ng-container *ngIf="stuff$ | async as stuffs">
      <ul *ngIf="stuffs.length > 0; else noStuff">
          <li *ngFor="let stuff of stuffs">
              <app-list-item [stuff]="stuff" (delete)="deleteStuff(stuff)" (toggleFavorite)="toggleFavorite(stuff, $event)"></app-list-item>
          </li>
      </ul>
    </ng-container>
    <ng-template #noStuff>
        <p>No stuff here! You should <a [routerLink]="['/new']">add one</a>...</p>
    </ng-template>
  `,
  styles: []
})
export class ListViewComponent {

  stuff$ = combineLatest([this.stuffService.stuff$, this.route.params]).pipe(
    map(([stuffs, params]) => {
      if (params.filter === 'favorites') {
        return stuffs.filter(s => s.favorite);
      }
      return stuffs;
    })
  );

  constructor(private stuffService: StuffService, private route: ActivatedRoute) {
  }

  toggleFavorite(stuff: Stuff, favorite: boolean) {
    this.stuffService.setFavorite(stuff.id, favorite);
  }

  deleteStuff(stuff: Stuff) {
    this.stuffService.delete(stuff.id);
  }

}
