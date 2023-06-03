export type StateObject = {
	ToString: (self: StateObject) -> string,
	Observe: (self: StateObject, callbackFn: (value: any) -> ()) -> RBXScriptConnection,
	Get: (self: StateObject) -> any,
	Set: (self: StateObject, value: any) -> (),
	Update: (self: StateObject, transform: (value: any) -> any) -> StateObject,
	Concat: (self: StateObject, value: string) -> StateObject,
	Decrement: (self: StateObject, value: number) -> StateObject,
	Increment: (self: StateObject, value: number) -> StateObject,

	Changed: RBXScriptSignal
}

export type StateModule = {
	new: (value: any) -> StateObject,
	is: (object: StateObject?) -> boolean,
}

return { }