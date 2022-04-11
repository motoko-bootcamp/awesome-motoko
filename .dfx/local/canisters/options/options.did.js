export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'multipleOfThree' : IDL.Func([IDL.Nat], [IDL.Opt(IDL.Nat)], []),
    'optionToNat' : IDL.Func([IDL.Opt(IDL.Nat)], [IDL.Nat], []),
  });
};
export const init = ({ IDL }) => { return []; };
