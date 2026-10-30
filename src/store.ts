import { createClient } from '@supabase/supabase-js';
import type { Event } from './domain';
const env = import.meta.env;
export const supabase = env.VITE_SUPABASE_URL && env.VITE_SUPABASE_ANON_KEY ? createClient(env.VITE_SUPABASE_URL,env.VITE_SUPABASE_ANON_KEY) : null;
const key='museart.events.v1';
export async function loadEvents():Promise<Event[]> { if(!supabase) return JSON.parse(localStorage.getItem(key)||'[]'); const {data,error}=await supabase.from('events').select('data').order('updated_at',{ascending:false}); if(error) throw error; return data.map(row=>row.data as Event); }
export async function saveEvent(event:Event) { if(!supabase){const events=await loadEvents(); localStorage.setItem(key,JSON.stringify([event,...events.filter(e=>e.id!==event.id)])); return;} const {data:{user}}=await supabase.auth.getUser(); if(!user) throw Error('Inicia sesión para guardar.'); const {error}=await supabase.from('events').upsert({id:event.id,owner_id:user.id,data:event,updated_at:event.updatedAt}); if(error) throw error; }
export async function deleteEvent(event:Event) { if(event.receipts.length||event.expenses.length||event.musicians.some(m=>m.paid)) throw Error('Este evento tiene movimientos. Cancélalo para conservar su historial.'); if(!supabase){localStorage.setItem(key,JSON.stringify((await loadEvents()).filter(e=>e.id!==event.id))); return;} const {error}=await supabase.from('events').delete().eq('id',event.id); if(error) throw error; }
