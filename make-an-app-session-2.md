
# Session 2

# 2.1 Making things interesting (Networking)

We could teach you view programming, or how to save things locally, but these are really pretty simple.

Instead, let's look at how networking works on iOS.

## iOS Networking Basics

Networking is a huge topic. There are heaps of failure modes, and complexities - particularly because iOS devices are often using the cellular network.

On iOS, networking is accomplished using tasks attached to a session. `URLSession.shared` accesses the default session and `dataTask(...)` can be used to create a data task.

Tasks take a completion handler closure which is then called with the result of the task, the url response (as a `URLResponse` object) and an error if obtained.

The task is actually run by calling `.resume()`.

Putting all this together, a networking call is relatively simple. A simple get for Google's homepage looks like this:
```swift
let url = URL(string: "www.google.com") else { return nil }
let urlRequest = URLRequest(url: url)
let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
    // Data will be the google homepage html.
})
task.resume()
```

Headers can be added using `.addValue(_:forHTTPHeaderField:)` on a `URLRequest` instance. (See https://developer.apple.com/reference/foundation/nsurlrequest)

> See the URLSession documentation for more https://developer.apple.com/reference/foundation/urlsession, and  https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/Introduction/Introduction.html for an overview of networking.

## Networking in practice

Usually developers will write a small library to wrap their networking code, since it will mostly be shared for all the requests. Nobody wants to add that auth token every time. Keep it DRY people. (https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

Today we'll be interacting with unsplash.com -- a site that provides super high quality photos, donated by photographers. It's an excellent project, and it has amazing images.

Unsplash has a 50 calls per hour limit for anonymous developers, so Ethan has written a proxy for us here at the iOS bootcamp. If you're working on this at home, use unsplash's API directly after creating a free developer acount. Get started here: https://unsplash.com/documentation#getting-started.

To get a feel for what we're dealing with, we'll make a request and print out the contents.

Here are the request details:
```
GET /photos/random
Host: available on the day (if you're at home, use api.unsplash.com)
Authorization: Client-ID ANYTHING (if you're at home, use your client id)
Accept-Version: v1
```

Have a crack at this yourself. Just wrap it in a method and call it from `viewDidLoad()` in `ViewController.swift` and go for it.

PRO TIP: You'll get a `Data` object from the request. To convert this to a string, use
```swift
let string = String(data: data, encoding: .utf8)
```

<details>
<summary><em>SOLUTION (SPOILERS)</em></summary><p>

```swift
guard let url = URL(string: "insert-endpoint-here/photos/random") else { return }
var urlRequest = URLRequest(url: url)
urlRequest.addValue("Client-ID ANYTHING", forHTTPHeaderField: "Authorization")
urlRequest.addValue("v1", forHTTPHeaderField: "Accept-Version")

return URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
    print("Data: \(String(describing: String(data: data, encoding: .utf8)))")
    print("URL response: \(String(describing: urlResponse))")
    print("Error: \(String(describing: error))")
})
```
</p></details>
<br>
<details>
<summary><em>GUARD...ELSE</em></summary><p>

>Guard is best explained as the else statement only of an if statement. It came about because of if let ... {} pyramids of doom.
>
>NOTE: `if let constant ... {}` creates a constant only available to the inside of the if block.
>
>They looked like this:
>```swift
>if let a = ... {
>    if let b = a... {
>        if let c = b... {
>            if let d = c... {
>                // Do something with d
>            }
>        }
>    }
>}
>```
>
>The solution was to add an equivalent statement which included the failure case
>```swift
>guard let a = ... else { return }
>guard let b = a... else { return }
>guard let c = b... else { return }
>guard let d = c... else { return }
>
>// Do something with d
>```
</p></details>

## Parsing the JSON

Here's example JSON from `/photos/random`.

<details>
<summary><em>JSON</em></summary><p>

```json
HTTP/1.1 200 OK
Content-Type: application/json
Date: Fri, 28 Apr 2017 09:05:51 GMT
Transfer-Encoding: chunked

{
    "categories": [],
    "color": "#10130C",
    "created_at": "2016-11-01T21:47:38-04:00",
    "current_user_collections": [],
    "downloads": 2576,
    "exif": {
        "aperture": "5.0",
        "exposure_time": "1/4000",
        "focal_length": "48",
        "iso": 3200,
        "make": "Nikon",
        "model": "NIKON D5200"
    },
    "height": 4000,
    "id": "Md5vvHf55fk",
    "liked_by_user": false,
    "likes": 33,
    "links": {
        "download": "http://unsplash.com/photos/Md5vvHf55fk/download",
        "download_location": "https://api.unsplash.com/photos/Md5vvHf55fk/download",
        "html": "http://unsplash.com/photos/Md5vvHf55fk",
        "self": "https://api.unsplash.com/photos/Md5vvHf55fk"
    },
    "location": {
        "city": null,
        "country": "United States",
        "name": "Crowders Mountain",
        "position": {
            "latitude": 35.2725727,
            "longitude": -81.2739073
        },
        "title": "Crowders Mountain, United States"
    },
    "slug": null,
    "updated_at": "2017-04-19T10:07:06-04:00",
    "urls": {
        "full": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52?ixlib=rb-0.3.5&q=100&fm=jpg&crop=entropy&cs=tinysrgb&s=9a47b97bc45395f45046a03e929dbc31",
        "raw": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52",
        "regular": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=c14e5149dde1d6f8533e97db5e688e7a",
        "small": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&s=65c1abe3339e7bcd6241b8a162383644",
        "thumb": "https://images.unsplash.com/photo-1478051173351-52b9492e9d52?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=c24aa4a2c793b14a2b281bb7c338214a"
    },
    "user": {
        "bio": "",
        "first_name": "Callistus",
        "id": "8pfAUhJHFZQ",
        "last_name": "Ndemo",
        "links": {
            "followers": "https://api.unsplash.com/users/carlis/followers",
            "following": "https://api.unsplash.com/users/carlis/following",
            "html": "http://unsplash.com/@carlis",
            "likes": "https://api.unsplash.com/users/carlis/likes",
            "photos": "https://api.unsplash.com/users/carlis/photos",
            "portfolio": "https://api.unsplash.com/users/carlis/portfolio",
            "self": "https://api.unsplash.com/users/carlis"
        },
        "location": " Asteroid B-612",
        "name": "Callistus Ndemo",
        "portfolio_url": null,
        "profile_image": {
            "large": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=ee8bbf5fb8d6e43aaaa238feae2fe90d",
            "medium": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=356bd4b76a3d4eb97d63f45b818dd358",
            "small": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=0ad68f44c4725d5a3fda019bab9d3edc"
        },
        "total_collections": 5,
        "total_likes": 59,
        "total_photos": 5,
        "updated_at": "2017-04-19T10:07:06-04:00",
        "username": "carlis"
    },
    "views": 202417,
    "width": 6000
}
```
</p></details>
<br>

Foundation includes support for JSON parsing and serialization using `JSONSerialization`. The declaration is shown below:
```
class func jsonObject(with data: Data,
                    options opt: JSONSerialization.ReadingOptions = []) throws -> Any
```

There's a few things to unpack here. This function is a class method on `JSONSerialization`, options includes a default parameter (and is an option set - a concept beyond the scope of today), and the call can throw, meaning it may error and must be 'tried' using the `try` keyword. The function also returns `Any` which may represent any type, meaning it must be first cast to another type to be used.

Putting all these things together:
```swift
var jsonDictionary: [String: AnyObject]? // AnyObject just means AnyObject
do {
    jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
} catch {
    print("JSON parsing failed")
}
```

<details>
<summary><em>DICTIONARIES IN SWIFT</em></summary><p>

> `[String: AnyObject]` is a swift dictionary where the key is of type `String` and the value is of type `AnyObject`. A Dictionary is like map in java, or a dict in python. Dictionaries are one of three swift collection types in swift along with `Array` and `Set` (think set theory).
>
> To set an element in a dictionary:
> ```swift
>var dictionary: [String: Int]
>dictionary["key"] = 42
>```
>
> And to access that element:
> ```swift
>let value = dictionary["key"] // value is of type Int?
>```
> Note that the return type of the call is optional. If the value doesn't exist the result of the subscript is `nil`. This is unlike and `Array` where subscripting out of bounds is an error. In array's case, this is a performance consideration. Dictionaries are much less performant than arrays.
>
> The manual for swift's collection types is here: https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html, and the reference page for swift dictionaries is here: https://developer.apple.com/reference/swift/dictionary

</p></details>
<br>
Now we have processed the data out of the dictionary, let's extract the url for the regular image url. In _javascript_ this would be `json.urls.regular`.

The JS in JSON stands for Javascript/JavaScript. The swift version _will_ be gross. You'll probably now wrestle with the compiler for 15 minutes to unpack the JSON.

<details>
<summary><em>SOLUTION (SPOILERS)</em></summary><p>

```swift
guard
    let dictionary = result as? [String: Any],
    let urls = dictionary["urls"] as? [String: String],
    let resourceAddress = urls["regular"]
    else {
        print("Unexpected JSON")
        return
}

print(resourceAddress)
```
</p></details>
