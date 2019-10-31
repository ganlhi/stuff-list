import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {Stuff} from './stuff';

@Component({
  selector: 'app-list-item',
  template: `
      <span>{{stuff.name}}</span>
      <input type="checkbox" [checked]="stuff.favorite" title="Favorite" (change)="toggleFavorite.emit(!stuff.favorite)">
      <button (click)="delete.emit()">X</button>
  `,
  styles: [
      `
          :host {
              display: flex;
              align-items: center;
          }
    `
  ]
})
export class ListItemComponent {
  @Input() stuff: Stuff;
  @Output() delete = new EventEmitter<void>();
  @Output() toggleFavorite = new EventEmitter<boolean>();
}
