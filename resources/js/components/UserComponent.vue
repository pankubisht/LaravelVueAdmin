<template>
 <v-data-table 
    item-key="name" 
    class="elevation-1" 
    loading:loading 
    loading-text="Loading... Please wait"
    :headers="headers"
    @pagination="paginate"
    :server-items-length="users.total"
    :options.sync="options"
    :items="users.data"
    :items-per-page=5
    show-select
    @input ="selectAll"
    :footer-props="{
       itemsPerPageOptions: [5,10,15],
       itemsPerPageText:'User Per Page',
       'show-current-page':true,
       'show-first-last-page':true
     }"
 >
  
    <template v-slot:top>
      <v-text-field @input ="searhIt"
        label="Search"
      ></v-text-field>
      <v-toolbar flat color="red">
        <v-toolbar-title>User Management System</v-toolbar-title>
        <v-divider
          class="mx-4"
          inset
          vertical
        ></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on }">
            <v-btn color="primary" dark class="mb-2" v-on="on">Add New Nser</v-btn>
            <v-btn color="primary" dark class="mb-2 mr-2"  @click="deleteAll">Delete</v-btn>
          </template>  
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>
            <v-form 
                method="post"
                v-model="valid"
                v-on:submit.stop.prevent ="save"
                >
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="12">
                    <v-text-field v-model="editedItem.name" label="User name" 
                    :rules= "[rules.required,rules.min]"></v-text-field>
                  </v-col>
                </v-row>
                <v-row v-if="editedIndex == -1">
                  <v-col cols="12" sm="12">
                    <v-text-field v-model="editedItem.email" label="Email" 
                    :rules= "[rules.required,rules.vaidEmail]"
                     :success-messages="success" :error-messages="error" @blur="cheakEmail">
                     </v-text-field>
                  </v-col>
                   <v-col cols="12" sm="12">
                    <v-text-field v-model="editedItem.password" type="password" label="Type Password" 
                    :rules= "[rules.required]"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12">
                    <v-text-field v-model="editedItem.rpassword" type="password" label="Retype Password"
                     :rules= "[rules.required]"></v-text-field>
                  </v-col>
                </v-row> 
                <v-row> 
                  <v-col cols="12" sm="12">
                    <v-select :rule="[rules.required]" :items="roles" v-model="editedItem.role"  label="Select role" ></v-select>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close">Cancel</v-btn>
              <v-btn type="submit" color="blue darken-1" text @click.prevent="save" :disabled="!valid">Save</v-btn>
            </v-card-actions>
            </v-form>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>
    <template v-slot:item.photo="{ item }">
      <v-edit-dialog>
        <v-list-item-avatar>
              <v-img
              :src="item.photo"
              aspect-ratio="1"
              class="gray lighten-2"
              ></v-img>
        </v-list-item-avatar>  
        <template v-slot:input>
          <v-file-input 
          v-model="editedItem.photo"
          label="Select File" 
          placeholder="Uploaded Avatar" 
          accept="image/jpg,image/png,image/jpeg"
          @change="uploadPhoto(item)"
          ></v-file-input>
        </template>
      </v-edit-dialog>    
    </template>
    <template v-slot:item.role = "{ item }">
        <v-edit-dialog large block persistent :return-value.sync="item.role"
        @save="updateRole(item)"
        >
        {{item.role}}
        <template v-slot:input>
          <h2>Change Role</h2>
        </template>
        <template v-slot:input>
          <v-select :items="roles" v-model="item.role"  label="Select role" :rule="[rules.required]" >
          </v-select>
        </template>
        </v-edit-dialog>
    </template>
    <template v-slot:item.actions="{ item }">
      <v-icon
        small
        class="mr-2"
        @click="editItem(item)"
      >
        mdi-pencil
      </v-icon>
      <v-icon
        small
        @click="deleteItem(item)"
      >
        mdi-delete
      </v-icon>
    </template>
    <template v-slot:no-data>
      <v-btn color="primary" @click="initialize">Reset</v-btn>
    </template>
    <v-snackbar
                v-model="snackbar"
              >
                Record Delete Successfully
                <v-btn
                  color="error"
                  text
                  @click="snackbar = false"
                >
                  Close
                </v-btn>
              </v-snackbar>
	</v-data-table>
 
</template>

<script>
  export default {
    data: () => ({
      valid:true,
      dialog: false,
      loading:false,
      snackbar:false,
      selected:[],
      roles:[],
      options:{
        sortBy:['name'],
        sortDesc:['true']
      },
      success:'',
      error:'',
      rules:{
        required: v => !!v || 'This Field is Required',
        min: v => v.length >=5 || 'Minimun 5 Charater Required',
        vaidEmail: v => /.+@.+\..+/.test(v) || 'E-mail must be valid'
      },
      headers: [
        { text: '#id', align: 'start',sortable: false,value: 'id'},
        { text: 'Name',  value: 'name' },
        { text: 'Email',  value: 'email' },
        { text: 'Role',  value: 'role' },
        { text: 'Photo',  value: 'photo' },
        { text: 'Created At',  value: 'created_at' },
        { text: 'Updated At',  value: 'updated_at' },
        { text: 'Actions', value: 'actions' },
      ],
      users: [],
      editedIndex: -1,
      editedItem: {
        id:'',
        name: '',
        email:'',
        role:'',
        password:'',
        created_at: '',
        updated_at: '',
        photo: null
      },
      defaultItem: {
        id:'',
        name: '',
        email:'',
        photo:'',
        password:'',
        rpassword:'',
        role:'',
        created_at: '',
        updated_at: '',
      },
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'New Item' : 'Edit Item'
      },
      passwordMatch(){
        return this.editedItem.password != this.editedItem.rpassword ? 'Password Does Not Match' : ''
      }
    },

    watch: {
      dialog (val) {
        val || this.close()
      },
    },

    created () {
      this.initialize()
    },

    methods: {
      uploadPhoto(item){
        if(this.editedItem.photo != null){

          const index = this.users.data.indexOf(item);
          let formData = new FormData();
          formData.append('photo', this.editedItem.photo, this.editedItem.photo.name)
          formData.append('user', item.id)
          axios.post('/laravel_v/public/api/user/photo', formData)
          .then(res => { 
            this.users.data[index].photo = res.data.user.photo
            this.editedItem.photo = null
          })
          .catch(err=>{
             this.text ="Photo Extetion not Valid So Use Only jpeg|png|jpg";
             this.snackbar =true
           })

        }

      },
      updateRole(item){
       const index = this.users.data.indexOf(item);
       axios.post('/laravel_v/public/api/user/role', {'role': item.role,'user': item.id})
       .then(res =>{
         this.text = res.data.user.name + "Role Updated to " + res.data.user,role
         this.snackbar = true
       })
       .catch(err =>{
         this.text = err.response.data.user.name + " Role Cannot Be Upadated to " + 
         err.response.data.user.role
         this.users.data[index].role = err.response.data.user.role
         this.snackbar =true
         })
      },
      selectAll(e){
        this.selected = [];
        if(e.length >0){
          this.selected = e.map(val => val.id)
        }
      },
      deleteAll(){
        let decided = confirm('Are you sure you want to delete these item?')
        if(decided){
         axios.post('/laravel_v/public/api/users/delete', {'users': this.selected})
         .then(res => {
           this.text ="Records Deleted Successfully";
            this.selected.map(val => {
              const index = this.users.data.indexOf(val)
              this.users.data.splice(index,1)
            })
            this.snackbar = true
           })
           .catch(err=>{
             this.text ="Error Deleted Records"
             this.snackbar =true
           })
        }   

      },
      searhIt(e){ console.log(e);
        if(e.length > 3){  
          axios.get(`/laravel_v/public/api/users/${e}`)
          .then(res => {  
          this.users = res.data.users
          this.snackbar =true
          })
          .catch(err=>{
             this.text = err.response?err.response:"Searchig length is grater then 3 Character"
             this.snackbar =true
           })
        }
        if(e.length <= 0){

          axios.get(`/laravel_v/public/api/users`)
          .then(res => this.users = res.data.pusers)
          .catch(err=>{
             this.text = err.response?err.response:"Searchig length is grater then one Character"
             this.snackbar =true
           })
        }
      },
      paginate(e){
        const sortBy = this.options.sortBy.length == 0 ? 'name' : this.options.sortBy[0]
        const orderBy = this.options.sortDesc.length > 0 || this.options.sortDesc[0] ? 'asc' : 'desc';
        axios.get(`/laravel_v/public/api/users?page=${e.page}`,{params:{'per_page': e.itemsPerPage,
        'sort_by':sortBy,'order_by':orderBy}})
          .then(res => {  
            this.users = res.data.users
            this.roles = res.data.roles
          })
          .catch(err=>{
              if(err.response.status == 401)
              localStorage.removeItem('token');
              this.$router.push('/login');
          })
      },
      initialize () {
        axios.interceptors.request.use((config) => { 
            this.loading = true;
            return config;
          }, (error) => {
            this.loading = false;
            return Promise.reject(error);
          });

        // Add a response interceptor
        axios.interceptors.response.use((response)=> {  
            this.loading = false;
            return response;
          }, (error) => {
            this.loading = false;
            return Promise.reject(error);
          });
           
      },
      editItem (item) { 
        this.editedIndex = this.users.data.indexOf(item)
        this.editedItem = Object.assign({}, item)
        this.editedItem.role = item.role.name
        this.dialog = true
      },

      deleteItem (item) {
        const index = this.users.data.indexOf(item)
        let decided = confirm('Are you sure you want to delete this item?')
        if(decided)
         axios.delete('/laravel_v/public/api/users/'+item.id)
         .then(res => {
           this.snackbar = true
           this.users.data.splice(index,1)
           })
          .catch(err=>{
             this.text = err.response?err.response:"Some issue is your data is not delete"
             this.snackbar =true
           })
        
      },

      close () {
        this.dialog = false
        setTimeout(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        },300)
      },

      save () {
        if (this.editedIndex > -1) {
          const index = this.editedItem
          axios.put('/laravel_v/public/api/users/'+this.editedItem.id,{'name':this.editedItem.name,'role':this.editedItem.role})
          .then(res =>{  
            this.text ="Record Update Successfully!";
            this.snackbar = true;
             Object.assign(this.users.data[index], res.data.user)
          })
          .catch(err=> {
            this.text = "Error Updating Records"
            this.snackbar =true 
          })
          
        } else {
          axios.post('/laravel_v/public/api/users', this.editedItem)
          .then(res =>  {
          this.text ="Record Added Successfully!";
          this.snackbar = true;
          this.users.data.push(res.data.user)})
          .catch(err=> {
            this.text = "Error Added Records"
            this.snackbar =true
          })
        }
        this.close()
      },
      cheakEmail(){
       if(/.+@.+\..+/.test(this.editedItem.email)){
         axios.post('/laravel_v/public/api/emailVerify', {'email': this.editedItem.email})
          .then(res => {
            this.success = res.data.message
            this.error = ''
          })
           .catch(err=>{
             this.success = ''
              this.error = "Email Already Exists"
           })
       }
      }
    },
  }
</script>