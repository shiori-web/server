class UnauthenticatedError < ::JSONAPI::Exceptions::Error
  def errors
    [create_error_object(
      code: 401,
      status: 401,
      title: '401 Unauthenticated!',
      detail: '403 Unauthenticated!'
    )]
  end
end
