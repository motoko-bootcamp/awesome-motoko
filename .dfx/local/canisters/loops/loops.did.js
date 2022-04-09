export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'for_loop' : IDL.Func([IDL.Vec(IDL.Text)], [], []),
    'if_else' : IDL.Func([IDL.Nat], [IDL.Text], []),
    'just_if' : IDL.Func([IDL.Bool], [IDL.Nat], []),
    'while_loop' : IDL.Func([IDL.Nat], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
