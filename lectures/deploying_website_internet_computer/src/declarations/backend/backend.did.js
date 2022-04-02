export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'getCurrentValue' : IDL.Func([], [IDL.Nat], ['query']),
    'incrementValue' : IDL.Func([], [IDL.Nat], []),
  });
};
export const init = ({ IDL }) => { return []; };
