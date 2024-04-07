use serde::{Deserialize, Serialize};
use serde_json::from_str;

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
struct Post {
    user_id: i32,
    id: i32,
    title: String,
    body: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
struct Comment {
    post_id: i32,
    id: i32,
    name: String,
    email: String,
    body: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
struct Photo {
    album_id: i32,
    id: i32,
    title: String,
    url: String,
    thumbnail_url: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
#[serde(rename_all = "camelCase")]
struct Todo {
    user_id: i32,
    id: i32,
    title: String,
    completed: bool,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct User {
    pub id: i32,
    pub name: String,
    pub username: String,
    pub email: String,
    pub address: Address,
    pub phone: String,
    pub website: String,
    pub company: Company,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Address {
    pub street: String,
    pub suite: String,
    pub city: String,
    pub zipcode: String,
    pub geo: Geo,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Geo {
    pub lat: String,
    pub lng: String,
}

#[derive(Default, Debug, Clone, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Company {
    pub name: String,
    pub catch_phrase: String,
    pub bs: String,
}

fn main() {
    let comments_json = std::fs::read_to_string("comments.json").unwrap();
    let photos_json = std::fs::read_to_string("photos.json").unwrap();
    let posts_json = std::fs::read_to_string("posts.json").unwrap();
    let todos_json = std::fs::read_to_string("todos.json").unwrap();
    let users_json = std::fs::read_to_string("users.json").unwrap();
    let comments: Vec<Comment> = from_str(&comments_json).unwrap();
    let photos: Vec<Photo> = from_str(&photos_json).unwrap();
    let posts: Vec<Post> = from_str(&posts_json).unwrap();
    let todos: Vec<Todo> = from_str(&todos_json).unwrap();
    let users: Vec<User> = from_str(&users_json).unwrap();
    println!("{:#?}", comments[0]);
    println!("{:#?}", photos[0]);
    println!("{:#?}", posts[0]);
    println!("{:#?}", todos[0]);
    println!("{:#?}", users[0]);
}
