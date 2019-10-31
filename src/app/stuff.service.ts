import {Injectable} from '@angular/core';
import {BehaviorSubject} from 'rxjs';
import {Stuff} from './stuff';

@Injectable({
  providedIn: 'root'
})
export class StuffService {

  private list$ = new BehaviorSubject<Stuff[]>([]);

  get stuff$() {
    return this.list$.asObservable();
  }

  add(stuff: string) {
    this.list$.next([...this.list$.getValue(), {id: this.createId(), name: stuff, favorite: false}]);
  }

  delete(id: number) {
    this.list$.next(this.list$.getValue().filter(s => s.id !== id));
  }

  setFavorite(id: number, favorite: boolean) {
    this.list$.next(this.list$.getValue().map(s => s.id !== id ? s : {...s, favorite}));
  }

  private createId(): number {
    const existingIds = this.list$.getValue().map(s => s.id);
    return existingIds.length > 0 ? Math.max(...existingIds) + 1 : 0;
  }
}
