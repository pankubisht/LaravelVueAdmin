<template>
 <v-data-table 
    item-key="name" 
    class="elevation-1" 
    loading:loading 
    loading-text="Loading... Please wait"
    :headers="headers"
    :server-items-length="roles.total"
    @pagination="paginate"
    :items="roles.data"
    :items-per-page=5
    show-select
    @input ="selectAll"
    :footer-props="{
       itemsPerPageOptions: [5,10,15],
       itemsPerPageText:'Role Per Page',
       'show-current-page':true,
       'show-first-last-page':true
     }"
    
    sort-by="calories"
 >
  
    <template v-slot:top>
      <v-text-field @input ="searhIt"
        label="Search"
      ></v-text-field>
      <v-toolbar flat color="red">
        <v-toolbar-title>Role Management System</v-toolbar-title>
        <v-divider
          class="mx-4"
          inset
          vertical
        ></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on }">
            <v-btn color="primary" dark class="mb-2" v-on="on">Add new role</v-btn>
            <v-btn color="primary" dark class="mb-2 mr-2"  @click="deleteAll">Delete</v-btn>
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>

            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="12">
                    <v-text-field v-model="editedItem.name" label="Role name"></v-text-field>
                  </v-col>
                  <!-- <v-col cols="12" sm="6" md="4">
                    <v-text-field v-model="editedItem.calories" label="Calories"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field v-model="editedItem.fat" label="Fat (g)"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field v-model="editedItem.carbs" label="Carbs (g)"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="4">
                    <v-text-field v-model="editedItem.protein" label="Protein (g)"></v-text-field>
                  </v-col> -->
                </v-row>
              </v-container>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" text @click="save">Save</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
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
      dialog: false,
      loading:false,
      snackbar:false,
      selected:[],
      headers: [
        {
          text: '#id',
          align: 'start',
          sortable: false,
          value: 'id',
        },
        { text: 'Name', value: 'name' },
        { text: 'Created At', value: 'created_at' },
        { text: 'Updated At', value: 'updated_at' },
        { text: 'Actions', value: 'actions', sortable: false },
      ],
      roles: [],
      editedIndex: -1,
      editedItem: {
        id:'',
        name: '',
        created_at: '',
        updated_at: '',
      },
      defaultItem: {
        id:'',
        name: '',
        calories: 0,
        created_at: '',
        updated_at: '',
      },
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'New Item' : 'Edit Item'
      },
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

      selectAll(e){
        this.selected = [];
        if(e.length >0){
          this.selected = e.map(val => val.id)
        }
      },
      deleteAll(){

        let decided = confirm('Are you sure you want to delete these item?')
        if(decided){
         axios.post('/laravel_v/public/api/roles/delete', {'roles': this.selected})
         .then(res => {
           this.text ="Records Deleted Successfully";
            this.selected.map(val => {
              const index = this.roles.data.indexOf(val)
              this.roles.data.splice(index,1)
            })
            this.snackbar = true
           }).catch(err=>{
             this.text ="Error Deleted Records"
             this.snackbar =true
           })
        }   

      },
      searhIt(e){
        if(e.length > 3){
          axios.get(`/laravel_v/public/api/roles/${e}`)
          .then(res => this.roles = res.data.roles)
          .catch(err=>{
             this.text = err.response?err.response:"Searchig length is grater then 3 Character"
             this.snackbar =true
           })
        }
        if(e.length <= 0){

          axios.get(`/laravel_v/public/api/roles`)
          .then(res => this.roles = res.data.roles)
          .catch(err=>{
             this.text = err.response?err.response:"Searchig length is grater then one Character"
             this.snackbar =true
           })
        }
      },
      paginate(e){
        axios.get(`/laravel_v/public/api/roles?page={e.page}`,{params:{'per_page': e.itemsPerPage}})
          .then(res => this.roles = res.data.roles)
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
        this.editedIndex = this.roles.data.indexOf(item)
        this.editedItem = Object.assign({}, item)
        this.dialog = true
      },

      deleteItem (item) {
        const index = this.roles.data.indexOf(item)
        let decided = confirm('Are you sure you want to delete this item?')
        if(decided)
         axios.delete('/laravel_v/public/api/roles/'+item.id)
         .then(res => {
           this.snackbar = true
           this.roles.data.splice(index,1)
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
          axios.put('/laravel_v/public/api/roles/'+this.editedItem.id,{'name':this.editedItem.name})
          .then(res =>{
            this.text ="Record Update Successfully!";
            this.snackbar = true;
             Object.assign(this.roles.data[index], res.data.role)
          })
          .catch(err=> {
            this.text = err.response?err.response:"Error Updating Records"
            this.snackbar =true 
          })
          
        } else {
          axios.post('/laravel_v/public/api/roles',{'name':this.editedItem.name})
          .then(res =>  {
          this.text ="Record Added Successfully!";
          this.snackbar = true;
          this.roles.data.push(res.data.role)})
          .catch(err=> {
            this.text = err.response?err.response:"Error Added Records"
            this.snackbar =true
          })
        }
        this.close()
      },
    },
  }
</script>