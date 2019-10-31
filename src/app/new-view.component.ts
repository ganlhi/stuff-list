import { Component, OnInit } from '@angular/core';
import {Router} from '@angular/router';
import {StuffService} from './stuff.service';

@Component({
  selector: 'app-edit-view',
  template: `
    <input [(ngModel)]="name" placeholder="Stuff name">
    <button (click)="addStuff()">Add</button>
  `,
  styles: []
})
export class NewViewComponent implements OnInit {
  name: string;

  constructor(private stuffService: StuffService, private router: Router) { }

  ngOnInit() {
    this.name = '';
  }

  addStuff() {
    if (this.name.length > 0) {
      this.stuffService.add(this.name);
      this.router.navigateByUrl('/list/all');
    }
  }

}
