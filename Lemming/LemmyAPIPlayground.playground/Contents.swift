import Foundation

let commentService = LemmyCommentService()

Task {
    let comments = await commentService.getComments(forPost: 22919)
}
    
    
