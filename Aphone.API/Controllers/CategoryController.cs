using Aphone.BAL.Interface;
using Aphone.Domain.Request.Category;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Aphone.API.Controllers
{
    [ApiController]
    public class CategoryController : ControllerBase
    {
        private readonly ICategoryService categoryService;

        public CategoryController(ICategoryService categoryService)
        {
            this.categoryService = categoryService;
        }
        [HttpGet]
        [Route("/api/category/gets")]
        public async Task<OkObjectResult> Gets()
        {
            return Ok(await categoryService.Gets());
        }
        [HttpPost]
        [Route("/api/category/create")]
        public async Task<OkObjectResult> Create(CreateCategoryRequest request)
        {
            return Ok(await categoryService.CreateCategory(request));
        }
        [HttpPost]
        [Route("/api/category/update")]
        public async Task<OkObjectResult> Update(UpdateCategoryRequest request)
        {
            return Ok(await categoryService.UpdateCategory(request));
        }
        [HttpDelete]
        [Route("/api/category/delete")]
        public async Task<OkObjectResult> Delete(DeleteCategoryRequest request)
        {
            return Ok(await categoryService.DeleteCategory(request));
        }
    }
}
