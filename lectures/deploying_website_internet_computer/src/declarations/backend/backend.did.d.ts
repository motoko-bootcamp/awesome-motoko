import type { Principal } from '@dfinity/principal';
export interface _SERVICE {
  'getCurrentValue' : () => Promise<bigint>,
  'incrementValue' : () => Promise<bigint>,
}
