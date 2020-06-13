<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\User;
use App\Profile;
use Auth;
use App\Role;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Hash;
use App\Http\Resources\User as UserResources;
use App\Http\Resources\UserCollection;

class UserController extends Controller
{

    public function index(Request $request)
    {  // echo'<pre>'; dd($request); echo'</pre>'; 
        $per_page = $request->per_page ? $request->per_page:5;
        $sortBy = $request->sort_by;
        $orderBy = $request->order_by;

        return response()->json([
            'users' => new UserCollection(User::orderBY($sortBy, $orderBy)->paginate($per_page)),
            'roles' => Role::pluck('name')->all()
        ],200);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {   
        $role = Role::where('name',$request->role)->first();
        $user = new User([
            'name' => $request->name,
            'email'=> $request->email,
            'password' => bcrypt($request->password),
        ]);
        $user->role()->associate($role);
        $user->save();
        $user->profile()->save(new Profile());
        return response()->json(['user'=> new UserResources($user)],200);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $users = User::where('name','LIKE', "%$id%")->paginate();
        return response()->json(['users'=> $users],200);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {   
        $role = Role::where('name',$request->role)->first();
        $user = User::find($id);
        $user->name = $request->name;
        $user->role()->dissociate($user->role);
        $user->role()->associate($role);
        $user->save();
        return response()->json(['user'=> new UserResources($user)],200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $user = User::find($id)->delete();
        Profile::where('user_id',$id)->delete();
        return response()->json(['user'=>$user,200]);
    }

    public function deleteAll(Request $request){  

        User::WhereIn('id',$request->users)->delete();
        
        return response()->json(['message'=>'Records Deleted Successfuly']);
    }

    public function login(Request $request){  

        $credentials = $request->only('email','password');
        if(Auth::attempt($credentials)){
            $token = Str::random(80);
            Auth::User()->api_token = $token;
            Auth::User()->save();
            $admin = Auth::User()->isAdmin();
            return response()->json(['token'=>$token,'isAdmin'=>$admin],200);
        }
        return response()->json(['status'=>'Email or Password is Wrong'],403);

    }

    public function verify(Request $request){  

        return $request->user()->only('name','email');

    }
    public function emailVerify(Request $request){  

        $request->validate([
            'email' => 'required|unique:users'
        ]);

        return response()->json(['message'=>'Valid Email'],200);

    }
    public function changeRole(Request $request){

        $role = Role::where('name', $request->role)->first();
        $user = User::find($request->user);
        $logInUser = $request->user();
        if($user->id == $logInUser->id){

            return response()->json(['user'=> new UserResources($logInUser)],422);

        }
        $user->role()->associate($role);
        $user->save();

        return response()->json(['user'=> new UserResources($user)],200);


    }

    public function changePhoto(Request $request){

        $user = User::find($request->user);
        $profile = Profile::where('user_id', $request->user)->first();
        $ext = $request->photo->extension();
        $photo = $request->photo->storeAs('images', Str::random(20).".{$ext}",'public');
        $profile->photo = $photo;
        $user->profile()->save($profile);
        return response()->json(['user'=> new UserResources($user)],200);
    }
}
