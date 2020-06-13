import Vue from 'vue';
import VueRouter from 'vue-router';
import LoginComponent from './components/LoginComponent';
import AdminComponent from './components/AdminComponent';
import RoleComponent from './components/RoleComponent';
import UserComponent from './components/UserComponent';

Vue.use(VueRouter)

const routes=[
                { path:'/',
                  redirect: '/login'
                },
                { path:'/login',
                  component: LoginComponent,
                  name:'login'
                },
                { path:'/admin',
                  component: AdminComponent,
                  name:'admin',
                  children:[
                  {
                    path:'roles',
                    component: RoleComponent,
                    name:'Roles'
                  },
                  {
                    path:'users',
                    component: UserComponent,
                    name:'Users'
                  }
                  ],
                  beforeEnter:(to, from, next)=>{
                    axios.get('/laravel_v/public/api/verify')
                    .then(res => next())
                    .catch(err => next('/login'))
                  }
                }
                ]
                const router = new VueRouter({routes}) 
                router.beforeEach((to, from, next)=>{
                  const  token = localStorage.getItem('token') || null
                  window.axios.defaults.headers['Authorization'] = "Bearer " + token;
                  next();

                });
               

        export default router