class UnauthorizedError < ::JSONAPI::Exceptions::Error
  def errors
    [create_error_object(
      code: 403,
      status: 403,
      title: '403 Forbidden!',
      detail: '403 Forbidden!'
    )]
  end
end
